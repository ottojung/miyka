import fs from 'fs';
import os from 'os';
import path from 'path';
import { resolveProjectPath } from '../src/resolve_project_path.js';

describe('resolveProjectPath', () => {
  const originalCwd = process.cwd();
  let tempDir;

  beforeEach(() => {
    tempDir = fs.mkdtempSync(path.join(os.tmpdir(), 'miyka-test-'));
    process.chdir(tempDir);
  });

  afterEach(() => {
    process.chdir(originalCwd);
  });

  it('throws error if id-map.csv is not found', () => {
    expect(() => resolveProjectPath(tempDir, 'projectA')).toThrow(/id-map\.csv/);
  });

  it('throws error if id-map.csv is empty', () => {
    fs.writeFileSync(path.join(tempDir, 'id-map.csv'), '');
    expect(() => resolveProjectPath(tempDir, 'anything')).toThrow(/empty/);
  });

  it('returns correct path for existing project', () => {
    const csv = 'id,name\n123,projectA\n';
    fs.writeFileSync(path.join(tempDir, 'id-map.csv'), csv);
    const projectId = '123';
    const runPath = path.join(tempDir, 'repositories', projectId, 'wd', 'run');
    fs.mkdirSync(path.dirname(runPath), { recursive: true });
    fs.writeFileSync(runPath, '');

    const result = resolveProjectPath(tempDir, 'projectA');
    expect(result).toBe(runPath);
  });

  it('throws error if project name not found', () => {
    fs.writeFileSync(path.join(tempDir, 'id-map.csv'), 'id,name\n123,projectA\n');
    expect(() => resolveProjectPath(tempDir, 'projectB')).toThrow(/project 'projectB' not found/);
  });

  it('throws error if id column is missing', () => {
    fs.writeFileSync(path.join(tempDir, 'id-map.csv'), 'name\nprojectA\n');
    expect(() => resolveProjectPath(tempDir, 'projectA')).toThrow(/id column/);
  });

  it('throws error if name column is missing', () => {
    fs.writeFileSync(path.join(tempDir, 'id-map.csv'), 'id\n123\n');
    expect(() => resolveProjectPath(tempDir, 'projectA')).toThrow(/name column/);
  });

  it('ignores extra columns and spaces', () => {
    const csv = 'id, name, extra\n  789 , projectC , value\n';
    fs.writeFileSync(path.join(tempDir, 'id-map.csv'), csv);
    const projectId = '789';
    const runPath = path.join(tempDir, 'repositories', projectId, 'wd', 'run');
    fs.mkdirSync(path.dirname(runPath), { recursive: true });
    fs.writeFileSync(runPath, '');

    const result = resolveProjectPath(tempDir, 'projectC');
    expect(result).toBe(runPath);
  });
});
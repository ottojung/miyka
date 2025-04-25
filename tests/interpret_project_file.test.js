// tests/interpret_project_file.test.js
// Unit tests for interpretProjectFile
/* eslint-env jest */
// Mock child_process.spawnSync to avoid running real commands
jest.mock('child_process', () => ({ spawnSync: jest.fn() }));

import fs from 'fs';
import os from 'os';
import path from 'path';
import { spawnSync } from 'child_process';
import { interpretProjectFile } from '../src/interpret_project_file.js';

describe('interpretProjectFile', () => {
  let tmpDir;
  beforeEach(() => {
    // Create a temporary project directory
    tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'pkg-'));
    // Default mock for spawnSync: success
    spawnSync.mockReturnValue({ error: null, status: 0 });
  });
  afterEach(() => {
    // Cleanup
    fs.rmSync(tmpDir, { recursive: true, force: true });
    jest.resetAllMocks();
  });

  it('installs dependencies and runs CLI when bin is string', () => {
    // Prepare a package.json with string bin
    const pkg = { name: 'mypkg', bin: 'cli.js' };
    fs.writeFileSync(path.join(tmpDir, 'package.json'), JSON.stringify(pkg));
    // Dummy project file
    const filePath = path.join(tmpDir, 'file.txt');
    fs.writeFileSync(filePath, '');

    interpretProjectFile(filePath);

    // spawnSync should be called twice: npm install, then CLI
    expect(spawnSync).toHaveBeenCalledTimes(2);
    expect(spawnSync).toHaveBeenNthCalledWith(
      1,
      'npm',
      ['install'],
      { cwd: tmpDir, stdio: 'inherit' }
    );
    const expectedBin = path.join(tmpDir, 'node_modules', '.bin', 'mypkg');
    expect(spawnSync).toHaveBeenNthCalledWith(
      2,
      expectedBin,
      [filePath],
      { cwd: tmpDir, stdio: 'inherit' }
    );
  });

  it('handles object bin field', () => {
    // Prepare a package.json with object bin
    const pkg = { name: 'mypkg', bin: { mycmd: 'cli.js', other: 'other.js' } };
    fs.writeFileSync(path.join(tmpDir, 'package.json'), JSON.stringify(pkg));
    const filePath = path.join(tmpDir, 'file.js');
    fs.writeFileSync(filePath, '');

    interpretProjectFile(filePath);

    expect(spawnSync).toHaveBeenCalledTimes(2);
    expect(spawnSync).toHaveBeenNthCalledWith(
      1,
      'npm',
      ['install'],
      { cwd: tmpDir, stdio: 'inherit' }
    );
    const expectedBin = path.join(tmpDir, 'node_modules', '.bin', 'mycmd');
    expect(spawnSync).toHaveBeenNthCalledWith(
      2,
      expectedBin,
      [filePath],
      { cwd: tmpDir, stdio: 'inherit' }
    );
  });

  it('throws if no bin field', () => {
    const pkg = { name: 'mypkg' };
    fs.writeFileSync(path.join(tmpDir, 'package.json'), JSON.stringify(pkg));
    const filePath = path.join(tmpDir, 'file.txt');
    fs.writeFileSync(filePath, '');
    expect(() => interpretProjectFile(filePath)).toThrow(/No "bin" field/);
  });

  it('throws if bin is invalid type', () => {
    const pkg = { name: 'mypkg', bin: 123 };
    fs.writeFileSync(path.join(tmpDir, 'package.json'), JSON.stringify(pkg));
    const filePath = path.join(tmpDir, 'file.txt');
    fs.writeFileSync(filePath, '');
    expect(() => interpretProjectFile(filePath)).toThrow(/Invalid "bin" field/);
  });

  it('throws if package.json cannot be read', () => {
    const filePath = path.join(tmpDir, 'file.txt');
    fs.writeFileSync(filePath, '');
    expect(() => interpretProjectFile(filePath)).toThrow(/Unable to read or parse package\.json/);
  });
});
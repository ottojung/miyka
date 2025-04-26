// @ts-nocheck
import * as fs from 'fs';
import * as path from 'path';
import { parse } from 'csv-parse/sync';

/**
 * Resolves a project name to the file path of its project file.
 * @param {string} projectName
 * @returns {string}
 */
/**
 * Resolves a project name to the file path of its project file.
 * @param {string} projectName
 * @returns {string}
 */
export function resolveProjectPath(projectName) {
    const root = process.cwd();
    const idMapPath = path.join(root, 'id-map.csv');
    let content;
    try {
        content = fs.readFileSync(idMapPath, 'utf8');
    } catch (err) {
        throw new Error(`Cannot find id-map.csv in root directory: ${root}`);
    }
    const records = parse(content, {
        columns: true,
        skip_empty_lines: true,
        trim: true,
    });
    if (!records || records.length === 0) {
        throw new Error('id-map.csv is empty');
    }
    const first = records[0];
    if (!Object.prototype.hasOwnProperty.call(first, 'id')) {
        throw new Error('id column not found in id-map.csv');
    }
    if (!Object.prototype.hasOwnProperty.call(first, 'name')) {
        throw new Error('name column not found in id-map.csv');
    }
    const record = records.find(r => r.name === projectName);
    if (!record) {
        throw new Error(`project '${projectName}' not found in id-map.csv`);
    }
    const foundId = record.id;
    return path.join(root, 'repositories', foundId, 'wd', 'run');
}

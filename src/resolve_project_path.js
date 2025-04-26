// @ts-nocheck
import * as fs from 'fs';
import * as path from 'path';

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
    const lines = content.split(/\r?\n/).filter(line => line.trim() !== '');
    if (lines.length === 0) {
        throw new Error('id-map.csv is empty');
    }
    const headers = lines[0].split(',').map(h => h.trim());
    const idIndex = headers.indexOf('id');
    if (idIndex === -1) {
        throw new Error('id column not found in id-map.csv');
    }
    const nameIndex = headers.indexOf('name');
    if (nameIndex === -1) {
        throw new Error('name column not found in id-map.csv');
    }
    let foundId = null;
    for (let i = 1; i < lines.length; i++) {
        const columns = lines[i].split(',').map(c => c.trim());
        if (columns[nameIndex] === projectName) {
            foundId = columns[idIndex];
            break;
        }
    }
    if (!foundId) {
        throw new Error(`project '${projectName}' not found in id-map.csv`);
    }
    return path.join(root, 'repositories', foundId, 'wd', 'run');
}

// @ts-nocheck
import * as fs from 'fs';
import * as path from 'path';
import { parse } from 'csv-parse/sync';
import logger from './logger.js';

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
    logger.info({ projectName }, 'Resolving project path');
    const root = process.cwd();
    const idMapPath = path.join(root, 'id-map.csv');
    logger.debug({ idMapPath }, 'Computed id-map.csv path');
    let content;
    try {
        logger.debug('Attempting to read id-map.csv');
        content = fs.readFileSync(idMapPath, 'utf8');
        logger.debug({ length: content.length }, 'Read id-map.csv successfully');
    } catch (err) {
        logger.error({ err }, `Cannot find id-map.csv in root directory: ${root}`);
        throw new Error(`Cannot find id-map.csv in root directory: ${root}`);
    }
    const records = parse(content, {
        columns: true,
        skip_empty_lines: true,
        trim: true,
    });
    if (!records || records.length === 0) {
        logger.error('id-map.csv is empty');
        throw new Error('id-map.csv is empty');
    }
    const first = records[0];
    logger.debug({ recordCount: records.length }, 'Parsed id-map.csv');
    if (!Object.prototype.hasOwnProperty.call(first, 'id')) {
        logger.error('id column not found in id-map.csv');
        throw new Error('id column not found in id-map.csv');
    }
    if (!Object.prototype.hasOwnProperty.call(first, 'name')) {
        logger.error('name column not found in id-map.csv');
        throw new Error('name column not found in id-map.csv');
    }
    const record = records.find(r => r.name === projectName);
    if (!record) {
        logger.warn({ projectName }, `Project not found in id-map.csv`);
        throw new Error(`project '${projectName}' not found in id-map.csv`);
    }
    const foundId = record.id;
    logger.debug({ foundId }, 'Found project ID');
    const projectFilePath = path.join(root, 'repositories', foundId, 'wd', 'run');
    logger.info({ projectName, projectFilePath }, 'Resolved project file path');
    return projectFilePath;
}

/**
 * Interprets the given project file.
 * @param {string} projectFilePath
 * @returns {void}
 */
import { spawnSync } from 'child_process';
import logger from './logger.js';


/**
 * Interprets the given project file by launching a shell.
 * @param {string} projectFilePath - Path to the script to execute.
 * @param {string[]} args - Optional arguments to pass to the script.
 * @returns {number} - The exit status of the process.
 */
export function interpretProjectFile(projectFilePath, args) {
    logger.debug({ projectFilePath, args }, 'Spawning shell for project file');
    const cmdArgs = [projectFilePath, ...args];
    const run = spawnSync('/bin/sh', cmdArgs, { stdio: 'inherit' });
    if (run.error) {
        logger.error({ err: run.error }, 'Failed to spawn shell for project file');
        throw run.error;
    }
    const status = run.status;
    if (status !== 0) {
        logger.debug({ status }, 'Project script exited with non-zero status code');
    } else {
        logger.debug({ status }, 'Project script exited successfully');
    }
    return status;
}

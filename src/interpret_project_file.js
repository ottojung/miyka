/**
 * Interprets the given project file.
 * @param {string} projectFilePath
 * @returns {void}
 */
import { spawnSync } from 'child_process';


/**
 * Interprets the given project file by launching a shell.
 * @param {string} projectFilePath - Path to the script to execute.
 * @param {string[]} [args] - Optional arguments to pass to the script.
 * @returns {number} - The exit status of the process.
 */
export function interpretProjectFile(projectFilePath, args = []) {
    const cmdArgs = [projectFilePath, ...args];
    const run = spawnSync('/bin/sh', cmdArgs, { stdio: 'inherit' });
    if (run.error) {
        throw run.error;
    }

    return run.status;
}

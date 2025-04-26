import { resolveProjectPath } from './resolve_project_path.js';
import { interpretProjectFile } from './interpret_project_file.js';
import logger from './logger.js';

/**
 * Handle the 'run' command.
 * Resolves the project file path from the project name and interprets it.
 * @param {string} root
 * @param {string} projectName
 * @param {string[]} args
 * @returns {void}
 */
export function run(root, projectName, args) {
    logger.debug({ projectName, args }, 'Run command handler started');
    logger.debug({ projectName }, 'Resolving project file path');
    const projectFilePath = resolveProjectPath(root, projectName);
    logger.debug({ projectFilePath }, 'Resolved project file path');
    logger.debug({ projectFilePath, args }, 'Invoking project script');
    const status = interpretProjectFile(projectFilePath, args);
    if (status !== 0) {
        logger.error({ status }, 'Project script exited with error');
        process.exit(status);
    } else {
        logger.debug({ status }, 'Project script completed successfully');
        process.exit(status);
    }
}

import { resolveProjectPath } from './resolve_project_path.js';
import { interpretProjectFile } from './interpret_project_file.js';

/**
 * Handle the 'run' command.
 * Resolves the project file path from the project name and interprets it.
 * @param {string} projectName
 * @returns {void}
 */
export function run(projectName) {
    const projectFilePath = resolveProjectPath(projectName);
    interpretProjectFile(projectFilePath);
}

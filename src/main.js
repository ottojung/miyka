import { Command } from 'commander';
import { run as runCommand } from './run.js';

/**
 * Virtual entrypoint.
 * @param {string[]} argv
 * @returns {number}
 */
export function main(argv) {
    /**
     * @type {string}
     */
    const HOME = process.env.HOME;
    if (HOME === undefined || HOME === '') {
        throw Error("$HOME environment variable must be set, but isnt.");
    }

    const program = new Command();

    program
        .name('miyka')
        .description('Command-line tool for managing lightweight, reproducible workspaces.')
        .version('0.1.0');

    program
        .option('--root <root>', "Path to the miyka private storage.", `${HOME}/.local/share/miyka/root`)
        .command('run <project_name>')
        .description('Run a project')
        .action((projectName) => {
            runCommand(projectName);
        });

    program.parse(argv);
    return 0;
}


/**
 * The main entrypoint.
 * @returns {void}
 */
export function entry() {
    main(process.argv);
}

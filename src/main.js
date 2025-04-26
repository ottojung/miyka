import { Command } from 'commander';
import { run as runCommand } from './run.js';
import logger from './logger.js';

/**
 * Virtual entrypoint.
 * @param {string[]} argv
 * @returns {number}
 */
export function main(argv) {
    logger.debug({ argv: argv.slice(2) }, 'Entered main function');
    /**
     * @type {string}
     */
    const HOME = process.env.HOME;
    logger.debug({ HOME }, 'Retrieved HOME environment variable');
    if (HOME === undefined || HOME === '') {
        logger.error('$HOME environment variable must be set but is undefined or empty');
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
        .argument('[...projectArguments]')
        .description('Run a project')
        .action((projectName, projectArguments) => {
            logger.info({ projectName, projectArguments }, 'Run command invoked');
            runCommand(projectName, projectArguments);
        });

    logger.debug('Parsing command-line arguments with Commander');
    program.parse(argv);
    return 0;
}


/**
 * The main entrypoint.
 * @returns {void}
 */
export function entry() {
    logger.debug('Starting CLI');
    try {
        main(process.argv);
    } catch (err) {
        logger.error({ err }, 'Unexpected error occurred');
        process.exit(1);
    }
}

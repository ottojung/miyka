'use strict'

import { Command } from 'commander';


/**
 * Adds two numbers.
 * @param {number} a
 * @param {number} b
 * @returns {number}
 */
export function add(a, b) {
    return a + b;
}


/**
 * The main entrypoint.
 * @param {string[]} argv
 * @returns {number}
 */
function main(argv) {
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
            console.log(`Running project ${projectName}`);
        });

    program.parse(argv);
    return 0;
}


if (typeof require !== 'undefined' && require.main === module) {
    main(process.argv);
}


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
if (typeof require !== 'undefined' && require.main === module) {
    const program = new Command();

    program
        .name('miyka')
        .description('Command-line tool for managing isolated, reproducible workspaces.')
        .version('0.1.0');

    program
        .command('run <project_name>')
        .description('Run a project')
        .action((projectName) => {
            console.log(`Running project ${projectName}`);
        });

    program.parse();
}

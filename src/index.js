
import { cac } from 'cac';

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
    const cli = cac('miyka');

    cli
        .command('run <project_name>', 'Run a project')
        .action((projectName) => {
            console.log(`Running project ${projectName}`);
        });

    cli.help();
    cli.parse();
}

/**
 * Interprets the given project file.
 * @param {string} projectFilePath
 * @returns {void}
 */
import * as path from 'path';
import * as fs from 'fs';
import { spawnSync } from 'child_process';

/**
 * Interprets the given project file by installing its dependencies and running its CLI.
 * @param {string} projectFilePath
 * @returns {void}
 */
export function interpretProjectFile(projectFilePath) {
    const projectDir = path.dirname(projectFilePath);
    // Install dependencies
    const install = spawnSync('npm', ['install'], { cwd: projectDir, stdio: 'inherit' });
    if (install.error) {
        throw install.error;
    }
    if (install.status !== 0) {
        throw new Error(`npm install failed with code ${install.status}`);
    }
    // Read package.json
    const pkgPath = path.join(projectDir, 'package.json');
    let pkg;
    try {
        const content = fs.readFileSync(pkgPath, 'utf8');
        pkg = JSON.parse(content);
    } catch (err) {
        throw new Error(`Unable to read or parse package.json at ${pkgPath}: ${err.message}`);
    }
    // If project has a build script, run it to compile sources
    if (pkg.scripts && typeof pkg.scripts.build === 'string') {
        const build = spawnSync('npm', ['run', 'build'], { cwd: projectDir, stdio: 'inherit' });
        if (build.error) {
            throw build.error;
        }
        if (build.status !== 0) {
            throw new Error(`npm run build failed with code ${build.status}`);
        }
    }
    // Determine the CLI script from the "bin" field in package.json
    let binName;
    let binScriptRelative;
    if (pkg.bin) {
        if (typeof pkg.bin === 'string') {
            if (!pkg.name || typeof pkg.name !== 'string') {
                throw new Error('package.json must have a valid "name" when "bin" is a string');
            }
            binName = pkg.name;
            binScriptRelative = pkg.bin;
        } else if (typeof pkg.bin === 'object') {
            const keys = Object.keys(pkg.bin);
            if (keys.length === 0) {
                throw new Error('No "bin" entries found in package.json');
            }
            binName = keys[0];
            binScriptRelative = pkg.bin[binName];
            if (typeof binScriptRelative !== 'string') {
                throw new Error(`Invalid bin entry for command "${binName}"`);
            }
        } else {
            throw new Error('Invalid "bin" field in package.json');
        }
    } else {
        throw new Error('No "bin" field specified in package.json');
    }
    const binScriptPath = path.join(projectDir, binScriptRelative);
    // Run the project's CLI using Node on the script
    const run = spawnSync('node', [binScriptPath, projectFilePath], { cwd: projectDir, stdio: 'inherit' });
    if (run.error) {
        throw run.error;
    }
    if (run.status !== 0) {
        throw new Error(`Command "${binName}" failed with code ${run.status}`);
    }
}

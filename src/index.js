import { entry } from './main.js';
import logger from './logger.js';

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
    logger.info('Starting CLI');
    try {
        entry();
    } catch (err) {
        logger.error({ err }, 'Unexpected error occurred');
        process.exit(1);
    }
}

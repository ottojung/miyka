import { entry } from './main.js';

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
    entry();
}


import environment from "./environment/ship.js";

/**
 * Environment manager.
 * @typedef {Object} Environment
 * @property {(key: string) => string} getEnv
 * @property {(key: string, value: string) => void} setEnv
 */

/**
 * @type {{ environment: Environment }}
 */
export default {
    environment
}

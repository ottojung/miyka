
/**
 * Set environment variable.
 * @param {string} name - The key.
 * @param {string} value - The value.
 * @returns {void}
 */
export function setEnvironmentVariable(name, value) {
    process.env[name] = value;
}

/**
 * Get environment variable.
 * @param {string} name - The key.
 * @returns {string?} - The value.
 */
export function getEnvironmentVariable(name) {
    const ret = process.env[name];
    if (ret === undefined) {
        return null;
    } else {
        return ret;
    }
}

export default {
    setEnv: setEnvironmentVariable,
    getEnv: getEnvironmentVariable,
}

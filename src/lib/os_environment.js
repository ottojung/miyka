
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
 * @returns {string} - The value.
 */
export function getEnvironmentVariable(name) {
  return process.env[name];
}

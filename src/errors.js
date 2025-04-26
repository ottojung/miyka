/**
 * Error type for CLI errors that should terminate the process with exit code 1.
 * Use this class to throw errors that should be caught by entry() and exit gracefully.
 */
export class CliError extends Error {}
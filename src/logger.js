/**
 * Logger module using pino.
 */
import pino from 'pino';

const env = process.env.NODE_ENV || 'development';

/** Pino logger instance. @type {pino.Logger} */
let logger;

if (env === 'test') {
  // Disable logging in test environment
  logger = pino({ level: 'silent' });
} else if (env !== 'production') {
  // Pretty-print logs in development (non-production)
  const transport = pino.transport({
    target: 'pino-pretty',
    options: {
      colorize: true,
      translateTime: 'yyyy-mm-dd HH:MM:ss.l o',
      ignore: 'pid,hostname'
    }
  });
  logger = pino({ level: process.env.LOG_LEVEL || 'info' }, transport);
} else {
  // JSON logs in production
  logger = pino({ level: process.env.LOG_LEVEL || 'info' });
}

export default logger;


import { nodeResolve } from '@rollup/plugin-node-resolve';

export default [
  {
    input: 'src/index.js',
    // Treat CLI dependencies as external to avoid bundling issues
    external: ['commander', 'pino'],
    output: [
      { file: 'dist/index.esm.js', format: 'esm' },
      {
        file: 'dist/index.cjs.js',
        format: 'cjs',
        // Add shebang for CLI invocation
        banner: '#!/usr/bin/env node'
      }
    ],
    plugins: [
      nodeResolve()
    ]
  }
];

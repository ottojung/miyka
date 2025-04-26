// Unit tests for interpretProjectFile
import { spawnSync } from 'child_process';
import { interpretProjectFile } from '../src/interpret_project_file.js';

jest.mock('child_process', () => ({
  spawnSync: jest.fn(),
}));

describe('interpretProjectFile', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('calls spawnSync with file path and provided args, returns status', () => {
    spawnSync.mockReturnValue({ error: null, status: 42 });
    const filePath = '/path/to/script.sh';
    const args = ['arg1', 'arg2'];

    const status = interpretProjectFile(filePath, args);

    expect(spawnSync).toHaveBeenCalledWith(
      '/bin/sh',
      [filePath, ...args],
      { stdio: 'inherit' }
    );
    expect(status).toBe(42);
  });

  it('uses empty args when none provided', () => {
    spawnSync.mockReturnValue({ error: null, status: 0 });
    const filePath = '/path/to/script.sh';

    const status = interpretProjectFile(filePath, []);

    expect(spawnSync).toHaveBeenCalledWith(
      '/bin/sh',
      [filePath],
      { stdio: 'inherit' }
    );
    expect(status).toBe(0);
  });

  it('throws error when spawnSync returns an error', () => {
    const error = new Error('spawn failed');
    spawnSync.mockReturnValue({ error, status: null });
    const filePath = '/path/to/script.sh';

    expect(() => interpretProjectFile(filePath, [])).toThrow('spawn failed');
  });
});
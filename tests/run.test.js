import { run } from '../src/run.js';
import { resolveProjectPath } from '../src/resolve_project_path.js';
import { interpretProjectFile } from '../src/interpret_project_file.js';

jest.mock('../src/resolve_project_path.js', () => ({
  resolveProjectPath: jest.fn(),
}));

jest.mock('../src/interpret_project_file.js', () => ({
  interpretProjectFile: jest.fn(),
}));

describe('run module', () => {
  // Stub process.exit so tests can assert calls without exiting
  beforeAll(() => {
    jest.spyOn(process, 'exit').mockImplementation(() => {});
  });
  afterAll(() => {
    process.exit.mockRestore();
  });

  // Clear mock history before each test
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should resolve project path and interpret the file', () => {
    const root = 'rootDir';
    const projectName = 'myProject';
    const args = [];
    resolveProjectPath.mockReturnValue('/fake/path/project.js');
    run(root, projectName, args);
    expect(resolveProjectPath).toHaveBeenCalledWith(root, projectName);
    expect(interpretProjectFile).toHaveBeenCalledWith('/fake/path/project.js', args);
    // Ensure run invoked process.exit
    expect(process.exit).toHaveBeenCalled();
  });
});

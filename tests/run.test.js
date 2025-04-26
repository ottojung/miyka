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
  beforeEach(() => {
    jest.resetAllMocks();
  });

  it('should resolve project path and interpret the file', () => {
    const root = 'rootDir';
    const projectName = 'myProject';
    const args = [];
    resolveProjectPath.mockReturnValue('/fake/path/project.js');
    run(root, projectName, args);
    expect(resolveProjectPath).toHaveBeenCalledWith(root, projectName);
    expect(interpretProjectFile).toHaveBeenCalledWith('/fake/path/project.js', args);
  });
});


import { add } from '../src/index.js';

describe('sanity check', () => {
    it('add(1, 2) should return 3', () => {
        expect(add(1, 2)).toBe(3);
    });
});

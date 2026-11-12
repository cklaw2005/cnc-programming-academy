const ALLOWED_G = new Set([0, 1, 2, 3, 17, 20, 21, 54, 90, 91]);
const ALLOWED_M = new Set([3, 5, 8, 9, 30]);
const initialState = () => ({ x: 0, y: 0, z: 0, units: 'mm', unitScale: 1, plane: 'G17', distance: 'G90', workOffset: 'G54', motion: 'rapid', spindle: 'off', coolant: false, feed: null, speed: null });

export function parseProgram(source = '') {
  const state = initialState();
  const blocks = [];
  const errors = [];
  const lines = String(source).split(/\r?\n/);
  lines.forEach((raw, lineIndex) => {
    const lineNo = lineIndex + 1;
    const clean = raw.replace(/\([^)]*\)/g, ' ').replace(/;.*$/, '').trim().toUpperCase();
    if (!clean) return;
    const words = clean.match(/[A-Z][+-]?(?:\d+(?:\.\d*)?|\.\d+)/g) || [];
    const residue = clean.replace(/[A-Z][+-]?(?:\d+(?:\.\d*)?|\.\d+)/g, ' ').replace(/^\s*N\d+\s*/, '').trim();
    if (residue) errors.push(`Line ${lineNo}: malformed or unsupported text “${residue}”.`);
    const values = {};
    const gCodes = [], mCodes = [];
    for (const word of words) {
      const letter = word[0];
      const value = Number(word.slice(1));
      if (letter === 'N') continue;
      if ('XYZIJFS'.includes(letter)) { if (letter in values) errors.push(`Line ${lineNo}: duplicate ${letter} word.`); values[letter] = value; continue; }
      if (letter === 'G' || letter === 'M') {
        if (!Number.isInteger(value)) { errors.push(`Line ${lineNo}: ${word} must be an integer code.`); continue; }
        const allowed = letter === 'G' ? ALLOWED_G : ALLOWED_M;
        if (!allowed.has(value)) errors.push(`Line ${lineNo}: unsupported ${letter}${String(value).padStart(2, '0')} in this educational Fanuc-style milling subset.`);
        else if (letter === 'G') { gCodes.push(value); applyG(value, state); }
        else { mCodes.push(value); applyM(value, state); }
        continue;
      }
      errors.push(`Line ${lineNo}: unsupported word ${word}.`);
    }
    for (const group of [[0,1,2,3],[17,18,19],[20,21],[90,91]]) {
      const found = [...new Set(gCodes.filter(code => group.includes(code)))];
      if (found.length > 1) errors.push(`Line ${lineNo}: conflicting G codes ${found.map(code => `G${String(code).padStart(2,'0')}`).join(' and ')} in one modal group.`);
    }
    for (const group of [[3,4,5],[8,9]]) {
      const found = [...new Set(mCodes.filter(code => group.includes(code)))];
      if (found.length > 1) errors.push(`Line ${lineNo}: conflicting M codes ${found.map(code => `M${String(code).padStart(2,'0')}`).join(' and ')} in one function group.`);
    }
    const hasPosition = ['X','Y','Z'].some(k => k in values);
    const start = { x: state.x, y: state.y, z: state.z };
    let end = { ...start };
    if (hasPosition) for (const axis of ['X','Y','Z']) if (axis in values) {
      const scaled = values[axis] * state.unitScale;
      end[axis.toLowerCase()] = state.distance === 'G91' ? start[axis.toLowerCase()] + scaled : scaled;
    }
    if ('F' in values) state.feed = values.F * state.unitScale;
    if ('S' in values) state.speed = values.S;
    let path = null;
    if (hasPosition) {
      const kind = state.motion === 'G00' ? 'rapid' : state.motion === 'G01' ? 'linear' : 'arc';
      path = { kind, start, end, clockwise: state.motion === 'G02', center: { x: start.x + (values.I || 0) * state.unitScale, y: start.y + (values.J || 0) * state.unitScale }, plane: state.plane };
      state.x = end.x; state.y = end.y; state.z = end.z;
    }
    blocks.push({ line: lineNo, source: raw, start, path, motion: state.motion === 'G00' ? 'rapid' : state.motion === 'G01' ? 'cut' : state.motion === 'G02' || state.motion === 'G03' ? 'arc' : null, state: { ...state } });
  });
  return { blocks, errors, finalState: { ...state } };
}

function applyG(code, state) {
  if (code === 0) state.motion = 'G00';
  if (code === 1) state.motion = 'G01';
  if (code === 2) state.motion = 'G02';
  if (code === 3) state.motion = 'G03';
  if (code === 17) state.plane = 'G17';
  if (code === 20) { state.units = 'inch'; state.unitScale = 25.4; }
  if (code === 21) { state.units = 'mm'; state.unitScale = 1; }
  if (code === 54) state.workOffset = 'G54';
  if (code === 90) state.distance = 'G90';
  if (code === 91) state.distance = 'G91';
}
function applyM(code, state) {
  if (code === 3) state.spindle = 'M03 clockwise';
  if (code === 5) state.spindle = 'off';
  if (code === 8) state.coolant = true;
  if (code === 9) state.coolant = false;
  if (code === 30) { state.programEnd = true; state.spindle = 'off'; state.coolant = false; }
}

export function stepProgram(parsed, index) {
  const next = Math.max(0, Math.min(parsed.blocks.length, index + 1));
  return { index: next, block: parsed.blocks[next - 1] || null, done: next >= parsed.blocks.length };
}

export function resetProgram() { return 0; }

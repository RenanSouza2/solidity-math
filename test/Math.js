const { expect } = require('chai');
const { BigNumber } = ethers;

async function waitTx(txPromisse) {
  const tx = await tx.txPromisse;
  await tx.wait();
}

function randByte()
{
  const rand = Math.random();

  const big = rand * 256;
  const int = Math.floor(big);
  return BigNumber.from(int);
}

function randArray(len, f) {
  const arr = [];
  for(let i=0; i<len; i++)
    arr.push(f());
  return arr;
}

function bigNumberToHex(big, size) {
  return big.toHexString().substring(2).padStart(size);
}

function combine(byteArr) {
  const bigStr = byteArr
    .map(num => bigNumberToHex(num, 2))
    .reduce((a, b) => a + b)
  
  return BigNumber.from('0x'.concat(bigStr));
}

function rand256() {
  const arr = randArray(32, randByte);
  return combine(arr);
}

function randCap(cap) {
  const q = BigNumber.from(2).pow(256);
  const r = q.mod(cap);
  const max = q.sub(r);
  while(1) {
    const rand = rand256();
    if(rand.lt(max))
      return rand.mod(cap);
  }
}

function randRange(min, max) {
  const diff = max.sub(min);
  const r = randCap(diff);
  return min.add(r);
}

const ONE = BigNumber.from(10).pow(18);
const TWO = dec18(2);

function dec18(num) {
  return ONE.mul(num);
}

function dec(num, base) {
  const _base = BigNumber.from(10).pow(base);
  return _base.mul(num);
}

describe('Math', async function () {
  let math;

  before(async function () {
    const Math = await ethers.getContractFactory('Math');
    math = await Math.deploy();
    await math.deployed();
  });

  describe('log2dec', async function () {
    it('value', async function () {
      const logs = [
        '000000000000000000',
        '137503523749934908',
        '263034405833793833',
        '378511623253729812',
        '485426827170241759',
        '584962500721156181',
        '678071905112637652',
        '765534746362977060',
        '847996906554950015',
        '925999418556223145'
      ].map(item => BigNumber.from(item));

      const sigma = BigNumber.from(30);

      for (let i=0; i<10; i++) {
        const x = dec(10 + i, 17);
        const y = await math.log2(x);

        const min = logs[i].sub(sigma);
        const max = logs[i].add(sigma);
        expect(y).within(min, max);
      }
    });
  });
});

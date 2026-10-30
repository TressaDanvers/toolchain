# Risc

#### Operands
| Kind | Meaning |
|---|---|
| `reg` | general register |
| `imm` | any literal |
| `[mem]` | memory at `[reg]` or `[reg+imm]` |

#### Data
| Mnemonic | Forms | Meaning |
|---|---|---|
| `mov` | `reg reg` | copy first to second |
| `mov` | `reg [mem]` | store to memory |
| `mov` | `[mem] reg` | load from memory |
| `let` | `reg imm` | load `imm` into `reg` |
| `push` | `reg` | push 64 bit `reg` on the stack |
| `pop` | `reg` | pop the stack into 64 bit `reg` |

#### Arithmetic And Logic
| Mnemonic | Forms | Meaning |
|---|---|---|
| `add` | `reg reg` | `first += second` |
| `add` | `reg imm` | `first += imm` |
| `sub` | `reg reg` | `first -= second` |
| `sub` | `reg imm` | `first -= imm` |
| `and` | `reg reg` | `first and= second` |
| `and` | `reg imm` | `first and= imm` |
| `or` | `reg reg` | `first or= second` |
| `or` | `reg imm` | `first or= imm` |
| `xor` | `reg reg` | `first xor= second` |
| `xor` | `reg imm` | `first xor= imm` |

#### Shift
| Mnemonic | Forms | Meaning |
|---|---|---|
| `shl` | `reg imm` | shift first left by `imm`, fill with zero, set flags |

#### Control Flow
| Mnemonic | Forms | Meaning |
|---|---|---|
| `cmp` | `reg reg` | set flags from `first - second` |
| `cmp` | `reg imm` | set flags from `first - imm` |
| `jmp` | `label` | jump to `label` |
| `je` | `label` | jump to `label` if equal |
| `jne` | `label` | jump to `label` if not equal |
| `jb` | `label` | jump to `label` if below |
| `call` | `label` | push return address, jump to `label` |
| `ret` | | pop address, jump to it |

#### System
| Mnemonic | Forms | Meaning |
|---|---|---|
| `syscall` | | call the kernel |

#### Directives
| Directive | Forms | Meaning |
|---|---|---|
| `db` | `imm ...` | write the bytes of each literal to the output |
| `:label` | | define `label` at the current address |

#### Literals
| Kind | Example | Meaning |
|---|---|---|
| `int` | `i31` | number in base 10 with 64 bits width maximum |
| `xint` | `0x1F` | number in base 16 with 64 bits width maximum |
| `hex` | `1F` | base 16 byte pairs, so `ABCD` is literally `AB` `CD` |
| `string` | `"abc"` | bytes of the characters |
| `label` | `:name` | address of the `label` |

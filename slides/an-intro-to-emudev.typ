#import "@preview/touying:0.7.3": *
#import themes.simple: *

#show: simple-theme.with(aspect-ratio: "16-9")

#set text(size: 14pt)
#show link: it => underline(text(fill: rgb("#1a5fb4"), it))

#slide[
  #place(top + center, dx: -280pt, dy: 50pt, image("_assets/nes.webp", width: 250pt))
  #place(top + center, dx: -90pt, dy: 50pt, image("_assets/gameboy.png", width: 120pt))
  #place(top + center, dx: 30pt, dy: 70pt, image("_assets/ds.webp", width: 150pt))
  #place(top + center, dx: 240pt, dy: 90pt, image("_assets/playstation.webp", width: 250pt))

  #place(bottom + left, dx: 30pt, dy: -40pt)[
    #text(size: 36pt, weight: "black")[An Intro to \ ]
    #text(size: 36pt, weight: "black")[Emulation Development \ ]
    #text(size: 16pt, weight: "thin", fill: gray)[Systems Reading Group]
  ]

  #place(bottom + right, dx: -30pt, dy: -40pt, align(right, text(
    size: 11pt,
  )[X / Twitter - #link("https://x.com/0xmukesh")[\@0xmukesh] \ Site - #link("https://0xmukesh.github.io")[0xmukesh.github.io]]))
]

== Scope of this presentation

Initially, I would focus on explaining what emulation is, purpose of emulators, different ways emulators are built and also different ways of software _mimicry_. After that, I would mainly talk about software-based emulation in deep using one of my #link("https://github.com/0xmukesh/tiny.nes")[interpreter-based NES emulator] as a reference. Before jumping into the internals of that emulator, I would first cover the basics of NES hardware architecture and later I will map those topics with the equivalent code sections in the codebase to get a better idea.

#place(center, dy: 10pt, figure(
  image("_assets/tiny-nes.png", width: 300pt),
  caption: [tiny.nes running Ballon Fight],
))

== What is Emulation?

Emulation is the process of making one computer behave like another by translating or reproducing its hardware and software behavior. Broadly, there are two kinds of emulation that are generally carried out, especially in retro game systems-related emulator development space:

- Hardware emulation
- Software emulation

In hardware emulation, the target system's circuitry is physically reconstructed, either built from scratch or implemented by reconfiguring the host hardware (using an FPGA) so the host hardware literally behaves like the target system's logic gates. Some of the common projects in terms of hardware emulation are building a #link("https://eli.lipsitz.net/posts/fpga-gameboy-emulator/")[FPGA-based Game Boy emulator], #link("https://tubetime.us/index.php/2016/05/15/placeholder/")[Transistor-scale replica of the MOS 6502 CPU]

#place(center, dx: -200pt, dy: 5pt, figure(
  image("_assets/fpga-gameboy.png", height: 200pt),
  caption: [#link("https://eli.lipsitz.net/posts/fpga-gameboy-emulator/")[FPGA based Game Boy emulator]],
))

#place(center, dx: 140pt, dy: 5pt, figure(
  image("_assets/monster-6502.jpg", width: 300pt),
  caption: [#link("https://tubetime.us/index.php/2016/05/15/placeholder/")[MOnSter 6502]: Transistor scale replica of MOS 6502],
))

== What is Emulation?

In software emulation, the target system's behavior is simulated by code, without physically reconstructing its circuitry. Broadly, it is equivalent to building an interpreter of the target CPU and its peripherals (video, audio, memory, etc.) that runs on the host hardware.

#place(center, dx: -200pt, dy: 20pt, figure(
  image("_assets/ps1-web-emulator.png", height: 280pt),
  caption: [#link("https://github.com/maxpoletaev/nupsx")[nuPSX]: Web-based PS1 emulator running Crash Bandicoot],
))

#place(center, dx: 200pt, dy: 20pt, figure(
  image("_assets/visual-6502.png", width: 370pt),
  caption: [#link("https://www.visual6502.org/JSSim/index.html")[Visual 6502]: MOS 6502 emulator at transistor level],
))

== What is Emulation?

Pokémon Red was originally made for the Game Boy, which uses the *Sharp LR35902* as its CPU, which is kinda a hybrid of *Zilog's Z80* and *Intel's 8080*. The emulators below interpret the Game Boy's CPU ISA instruction by instruction and separately emulate the graphics (tilemaps, sprites, scanlines) in software to produce a framebuffer, which is then rendered to the screen using the host platform's graphics API, with audio and input handled similarly.

#place(top + left, dy: 130pt, figure(
  image("_assets/pokemon-red-android.png", width: 400pt),
  caption: [Pokémon Red running on Android],
))

#place(top + right, dy: 130pt, figure(
  image("_assets/pokemon-red-windows-7.jpg", width: 380pt),
  caption: [Pokémon Red running on Windows 7],
))

== Different ways of software _mimicry_

There are many different ways to run a program meant for architecture `A` on a computer that uses a different one.

=== If both have a different ISA

- *Interpreting the program*: Decoding each instruction of the program and performing the equivalent operation on the host CPU, one instruction at a time. This is the most common approach for writing emulators for retro 2D systems like NES, SNES, Game Boy, and Game Boy Advance, because their clock speeds are so much slower than modern machines that even an interpreter runs them far faster.
- *Binary translation*: Translating the program from architecture A to architecture B. This can be done in two ways:
  - *Static translation*: The whole program is translated ahead of time, or
  - *Dynamic translation / Just-in-Time (JIT)*: Blocks of the program are translated at runtime, cached, and reused later. This is what #link("https://support.apple.com/en-us/102527")[Rosetta 2], #link("https://qemu.org")[QEMU] and #link("https://dolphin-emu.org/")[Dolphin] do under the hood.

=== If both have the same ISA

- *Virtualization*: Runs the program natively on the same ISA, so no translation is involved. A hypervisor isolates a complete, unmodified guest OS (e.g., Windows in a VM on Linux) using hardware features like Intel VT-x and AMD-V. Performance is near-native, but it carries the overhead of a full second OS.
- *Compatibility layers*: No OS in the loop. The layer intercepts the API calls a program makes and reimplements them with host APIs. #link("https://www.winehq.org/")[Wine] and #link("https://www.protondb.com/")[Proton] do this for Windows software on Linux. Much lighter than a VM, but only covers the APIs the layer implements.

== Anatomy of a game emulator

#place(center, dy: 20pt, figure(
  image("_assets/game-emu-anatomy.png", width: 380pt),
  caption: [Stripped down anatomy of a game emulator. Based of Von Neumann architecture],
))

== Hardware architecture of NES

#place(center, dy: 50pt, figure(
  image("_assets/nes-motherboard-unmarked.webp", width: 400pt),
  caption: [NES motherboard. Credits: #link("https://www.copetti.org/writings/consoles/nes/")[Rodrigo Copetti]],
))

== Hardware architecture of NES

#place(center, dy: 50pt, figure(
  image("_assets/nes-motherboard-marked.webp", width: 400pt),
  caption: [Marked version of NES motherboard. Credits: #link("https://www.copetti.org/writings/consoles/nes/")[Rodrigo Copetti]],
))

== Hardware architecture of NES

#place(top + left, dy: 50pt, figure(
  image("_assets/nes-cartridges.jpg", width: 400pt),
  caption: [NES cartridges],
))

#place(top + right, dx: -50pt, dy: 50pt, figure(
  image("_assets/nes-cartridges-internal-unmarked.webp", width: 250pt),
  caption: [NES cartridge chip],
))

#place(top + right, dx: -30pt, dy: 200pt, figure(
  image("_assets/nes-cartridges-internal-marked.webp", width: 250pt),
  caption: [Marked version of NES cartridge chip],
))

== Hardware architecture of NES

The Nintendo Entertainment System (NES) was released in Japan in 1983 under the name *Famicom* and was later redesigned and launched in North America as the *NES* in 1985, following the 1983 North American video game market crash. If you wanted to build a software emulator for the NES in the early 2000s, you would have had to reverse engineer the hardware yourself by probing the buses and writing test ROMs in 6502 assembly. Luckily, that heavy lifting has already been done by experienced reverse engineers, and the information is freely available on the internet through the #link("https://nesdev.org")[NesDev Wiki].

The specifications of the NES are:

- *CPU*: Ricoh 2A03, a modified version of the 8-bit MOS 6502 processor with the Audio Processing Unit (APU) integrated into it. It uses an 8-bit data bus, a 16-bit address bus, and has three general-purpose registers (`X`, `Y`, and `A`), along with an 8-bit stack pointer. The `A` register is directly connected to the ALU.
- *RAM*: 2 KB of internal RAM, referred to as Work RAM (WRAM).
- *PPU*: The CPU by itself is not powerful enough to handle both graphics and audio simultaneously, so a separate chip is dedicated to rendering graphics to the screen. It has access to 2 KB of internal RAM, referred to as Video RAM (VRAM).
- *APU*: The Audio Processing Unit (APU) is embedded into the CPU. It provides five different sound channels: two pulse channels, one triangle channel, one noise channel, and one DMC channel.
- *Screen resolution*: 256×240 pixels, with 54 colors displayed simultaneously from a palette of 64 colors.
- *ROM*: Up to 32 KB of program code and 8 KB of graphics data. This can be expanded using mappers.

The NES uses *memory-mapped I/O*, so interacting with hardware is done entirely by reading from and writing to special addresses in the memory map. Since the NES uses a 16-bit address bus, its total addressable memory space is *64 KB* (\$0000–\$FFFF). More about the individual sound channels and the role of mappers will be covered in later sections.

== iNES file format

Before looking into the interpreter for Ricoh 2A03, we have to first figure out how are the physical cartridges distributed on the internet. NES games are distributed using a file format called #link("https://www.nesdev.org/wiki/INES")[iNES]. It is a very minimal file format which contains a header and the program code and graphics data is stored in a sequential fashion right after the header.

For extracting the program code and graphics data from the cartridge to a file on the computer, people use ROM dumpers.

#place(center, dx: -150pt, dy: 60pt, figure(
  image("_assets/nes-rom-dumper.jpg", width: 300pt),
  caption: [NES ROM dumper],
))

#place(center, dx: 200pt, dy: 80pt, figure(
  image("_assets/custom-n64-rom-dumper.jpg", width: 300pt),
  caption: [Custom N64 ROM dumper],
))

== iNES file format

#place(center, dx: -200pt, dy: 20pt, figure(
  image("_assets/ines.png", height: 370pt),
  caption: [#link("https://linux.die.net/man/1/xxd")[`xxd`] preview of iNES file],
))

#place(center, dx: 200pt, dy: 20pt, figure(
  image("_assets/ines-header.png", width: 350pt),
  caption: [iNES header],
))

== CPU

The Ricoh 2A03 is based on the MOS 6502 microprocessor. It is an 8-bit microprocessor, meaning 8 bits is the amount of data it can operate on in a single go as its fundamental unit. It uses a 16-bit address bus, meaning the size of the total address space is 64 KB. Apart from the program counter, stack pointer, and processor status, there are 3 other general purpose registers - `X`, `Y` and `A`. The `A` register is also connected to the ALU, so all the results of arithmetic operations are stored / "accumulated" within it.

(Code walk-through: https://github.com/0xMukesh/tiny.nes/blob/8676d5bb6031344b6ec56c7b152ea3e60982be06/internal/cpu/cpu.go)

#place(center, dx: -150pt, dy: 20pt, figure(
  image("_assets/nes-cpu.png", width: 500pt),
  caption: [Ricoh 2A03 memory map and registers],
))

#place(center, dx: 220pt, dy: 120pt, figure(
  image("_assets/cpu-status-flags.png", width: 400pt),
))

== CPU

One of the very interesting aspects of 6502 is its addressing modes. They are different ways an instruction can specify where the operands lives at. 6502 has 13 of them:

- *Implied/Implicit*: No operand needed. The operand / destination can be inferred from the instruction itself. (ex: `CLC`)
- *Accumulator*: Operates directly on `A` register. (ex: `ASL A`)
- *Immediate*: Uses 8-bit operand itself as the value, rather than fetching a value from a memory address. (ex: `LDA #$10`)
- *Zero Page*: Fetches the value from an 8-bit address, i.e. addressing only the first 256 bytes. (ex: `LDA $10`)
- *Zero Page, X*: Same as zero page but adds the value of `X` register to the zero page address, with wraparound.
- *Zero Page, Y*: Same as zero page but adds `Y` instead of `X`.
- *Absolute*: Fetches the value from a full 16-bit address. (ex: `LDA $1234`)
- *Absolute, X*: Absolute address plus `X` register, useful for indexing into arrays.
- *Absolute, Y*: Absolute address plus `Y` register.
- *Indirect*: Operand points to a memory location that holds the actual target address. Used only by `JMP`. (ex: `JMP ($1234)`)
- *Indexed Indirect (Indirect, X)*: Adds `X` to a zero-page address, then reads a 16-bit address from that location and uses it as the target. (ex: `LDA ($10,X)`)
- *Indirect Indexed (Indirect), Y*: Reads a 16-bit base address from a zero-page location, then adds `Y` to it to get the target. (ex: `LDA ($10),Y`)
- *Relative*: Uses a signed 8-bit offset from the current program counter. Used only by branch instructions. (ex: `BEQ $10`)

Ref: https://www.nesdev.org/wiki/CPU_addressing_modes

== CPU

Interrupts are a mechanism via the programmer can signal the CPU to stop what it is currently doing, go handle something more _urgent_ and then come back to where it left off. If interrupts weren't present then the CPU would have to constantly keep polling events from different hardware peripherals, which would waste a lot of CPU cycles and timing wouldn't be accurate as well.

In 6502, there are two kind of interrupts -- ordinary interrupt request (`IRQ`) and non-maskable interrupt (`NMI`). The CPU can choose to ignore the former using the interrupt disable flag in processor status register. `NMI` is used to render the graphics on the screen.

The way interrupts are handled is that CPU currently finishes its instruction and then saves its state by pushing the program counter and processor status flags onto the stack. It then jumps to a fixed location in the memory (interrupt vector) which holds the address of the actual handler. After the interrupt handler is executed, it then executes the `RTI` and restores the CPU state.

== Other interesting stuff

- *Fanatasy consoles*: PICO-8
- #link(
    "https://andrewkelley.me/post/jamulator.html",
  )[Static recompilation of NES games into native executables via LLVM]
- #link(
    "https://filthypants.blogspot.com/2010/12/snes-emulation-reaches-another-accuracy.html",
  )[Physically destroying chips to emulate them (SNES coprocessor decapping)]

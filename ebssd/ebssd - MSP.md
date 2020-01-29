# ebssd - MSP

---

- vor/nachteile von dingen?
- warum macht man das?


- alle syscalls erklären fork() ...
- paging erklären
- MBR
- buildroot vs. busybox
- HW access: sysfs / device-fs / dev/mem
- buffered/unbuffered file-IO
- filesystems / journaling etc..
- CGI / SGI script
- Opensource Licenses
- Android App lifecycle, activities beenden etc.
- Android wo wird was kompliliert, !Android version


---

- Kernelmodule with Deviceinterface cannot set permissions on the node

- modprobe vs. insmod
> modprobe handles dependencies and uses insmod to load .ko files

- when using insmod...
> Kernel-**Macro** Function `module_init()`

- makefile code to create Kernel Module
> `obj-m=xyz.o` from `xyz.ko`

- Wo ist der Flash Transition Layer?
> On the flash device itself as firmware. 
> Contains erasing, wear leveling and ECC. FTL in block device driver possible.

- Welches Filesystem ist am besten für Flash?
> Log Structured!

- Wann ist wear leveling am effizientesten?
> bei fast leerer Partition

- Wo ist die Hardware Konfiguration
> im Device Tree Binars (dtb)

- Was macht `copy_from_userspace`?
> Kopiert Daten aus dem User Space in den privilegierten Kernel Space.

- Welches Wear Leveling ist besser (statisch/dynamisch)?
> dynamic = only on rewrite (not applied to read only blocks)
> static = all blocks

- Wann geschehen keine Syscalls?
> - unbuffered file io
> - buffered file io
> - **both!** (bei jedem File IO)

- Was ist ein Device Tree?

- Wo werden Page Faults gehandlet?
> im Kernel

- Wann hat man den grössten Vorteil von Paging?
> Wenn man Shared Libs benutzt (?)

- Was ist `ioctl()` ?
> Syscall für Treiberspezifische Settings

- Welchen Addressspace benutzen Shared Libs?
> Their own, hence "shared". 
> Multiple processes use the same physical address space of the library.

- Wie greift man am schnellsten auf Peripherieregister zu?
> mit `mmap()` (Memory Map)

- Was ist on Demand Paging? Wann wird es benutzt?
> Nur wenn Page Faults passieren.

- Welche `libc` verwendet das Wandboard?
> glibc

- Warum ist ein normales Linux nicht Hard-Realtime fähig?
> Energieverbrauch & Performance

- Vergleich von Lizenzen (Copyleft)


- Bei welcher File-IO Variante finden mehr Syscalls statt?
> unbuffered/buffered/beide?

- Welches Build-Frameword wird verwendet um das Wandboard Rootfs zu erstellen?
> Buildroot

- Was ist Busybox?
> Enthält abgespeckte varianten von oft verwendeten Linux Commands in einer einzigen Binary

- Welche Art von Devicenodes lassen sich ins Filesystem mounten?
> Blockdevices

- Major/Minor Devicenode


- Was macht der ROM Bootloader?
> Linux Kernel und DTB vom Bootmedium (SDcard) ins DRAM laden.

- Was ist ein initial RAM Disk Image?


- Beim Lesen/Schreiben auf eine Datei via Unbuffered Syscalls
findet Datenbufferung statt?


- Was ist das erste vom Kernel gestartete Programm?
> `/sbin/init`


- Beim CGI startet der Webserver das Skript
als separaten Child-Process (?)

- Beim Hardwarezugriff aus dem Userspace findet kein Context Switch statt wenn:
über eine Device Node zugegriffen wird.


- wozu dient fork() überhaupt und was passiert beim Aufruf von fork()? 
> der gesammte Prozess wird dupliziert (unabhängige PID)

- wozu dient Paging?
> Auslagern von Memory auf die Disk
> Zugriffsrechte (Kernel vs. Userspace)
> Schreibschutz (readonly)

- Welche grundlegenden Mechanismen gibt es um auf Hardware zuzugreifen und wodurch unterscheiden sich diese?
> **Sysfs**: Einfacher Zugriff über Pseudodateien nur auf einfache Schnittstellen (Wenige Parameter) 
> - Softwaremässiges pollen (hohe/unnötige CPU-Last) 
> - Asynchron Notification (Schnelles Reagieren auf Hardwareinterrupts, Peripherien müssen Interrupt-fähig sein 
> **Device-Nodes**: wird für komplexe Schnittstellen verwendet (Viele Einstellungsparameter), oft Hilfs-Libraries im Hintergrund 
> **/dev/mem**: Direktes pagen der HW-Register in den Userspace -> Quick and dirty Notlösung



 



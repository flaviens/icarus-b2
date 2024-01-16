# Runtime error in Icarus

To reproduce, run `bash run.sh` in this directory.

Expected result: 

```
Output signature:           0x1400000.
```


Actual result:

```
Output signature:           0.
```

Specifically, the value of `celloutsig_2z` is expected to be `0x1400000` but is `0`.
This can be viewed in the produced `icarus_dump.vcd` file.

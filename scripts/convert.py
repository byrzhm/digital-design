def binary2decimal(binary: str) -> int:
    return int(binary, 2)

def decimal2binary(decimal: int) -> str:
    return f"{decimal:08b}"

def char2binary(char: str) -> str:
    assert len(char) == 1, "char2binary() takes a single character"
    return f"{ord(char):08b}"

def binary2char(binary: str) -> str:
    assert len(binary) <= 8, "binary2char() takes a binary string of length <= 8"
    return chr(binary2decimal(binary))

def decimal2char(decimal: int) -> str:
    return chr(decimal)

def char2decimal(char: str) -> int:
    return ord(char)

def hex2binary(hexadecimal: str) -> str:
    return f"{int(hexadecimal, 16):08b}"

def binary2hex(binary: str) -> str:
    return f"{int(binary, 2):02x}"

def hex2char(hexadecimal: str) -> str:
    return binary2char(hex2binary(hexadecimal))

def char2hex(char: str) -> str:
    return binary2hex(char2binary(char))
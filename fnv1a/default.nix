with builtins;

# implementation of the Fowler–Noll–Vo hash function
# Probably not as fast as one would like because it needs division because Nix
# can't do bit shifting, but maybe this gets optimized away.

# The 32 bit version works correctly for all inputs
# The 64 bit version might not, because Nix only has signed 64 bit integers

rec {
  test = byte4 4294967295;

  byte1 = bitAnd 255;
  byte2 = input: bitAnd 65280 input / 256;
  byte3 = input: bitAnd 16711680 input / 65536;
  byte4 = input: bitAnd 4278190080 input / 16777216;
  byte5 = input: bitAnd 1095216660480 input / 4294967296;
  byte6 = input: bitAnd 280375465082880 input / 1099511627776;
  byte7 = input: bitAnd 71776119061217280 input / 281474976710656;
  byte8 = input: bitAnd (-72057594037927936) input / 72057594037927936;

  fun = { n }: fnv1a_64 n;

  fnv1a_32 = let
    prime = 16777619;
    bias = 2166136261;
  in input: let
    hash1 = bias;
    data1 = byte1 input;
    hash2 = bitAnd (bitXor hash1 data1 * prime) 4294967295;
    data2 = byte2 input;
    hash3 = bitAnd (bitXor hash2 data2 * prime) 4294967295;
    data3 = byte3 input;
    hash4 = bitAnd (bitXor hash3 data3 * prime) 4294967295;
    data4 = byte4 input;
    result = bitAnd (bitXor hash4 data4 * prime) 4294967295;
  in result;

  fnv1a_64 = let
    prime = 1099511628211;
    bias = -3750763034362895579;
  in input: let
    hash1 = bias;
    data1 = byte1 input;
    hash2 = bitXor hash1 data1 * prime;
    data2 = byte2 input;
    hash3 = bitXor hash2 data2 * prime;
    data3 = byte3 input;
    hash4 = bitXor hash3 data3 * prime;
    data4 = byte4 input;
    hash5 = bitXor hash4 data4 * prime;
    data5 = byte5 input;
    hash6 = bitXor hash5 data5 * prime;
    data6 = byte6 input;
    hash7 = bitXor hash6 data6 * prime;
    data7 = byte7 input;
    hash8 = bitXor hash7 data7 * prime;
    data8 = byte8 input;
    result = bitXor hash8 data8 * prime;
  in result;

}

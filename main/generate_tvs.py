import random



def add_sub(length: int, AddnSub: str, A_String, B_String):

    Carries = [0]*(length+1)
    Sums = [0]*length
    Carries[length] = AddnSub
    if AddnSub == '1':
        x = B_String
        B_String = ''.join('1' if b == '0' else '0' for b in B_String)  # Flip bits of B
        #print(f"Original: {x}")
        #print(f"New     : {B_String}")

    for i in range(length-1,-1,-1):
        A_i = int( A_String[i] )
        B_i = int( B_String[i] )
        C_i = int( Carries[i+1] ) 
        Suum = A_i ^ B_i ^ C_i
        Cout = ( A_i & B_i ) | ( C_i & (A_i ^ B_i))
        Sums[i] = Suum
        Carries[i] = Cout

    #print(f"Operands: {A_String} + {B_String} + {Cin}, Expected Sum: {Sums}, Expected Cout: {Carries[0]}, Expected Ovfl: {Carries[0]  ^ Carries[1]}")

    #return A+B+Cin, Cout, Ovfl
    return Sums, Carries[0], (Carries[0] ^ Carries[1])

def add_sub_word(length: int, AddnSub: str, A_String, B_String):

    Carries = [0]*(length+1)
    Sums = [0]*length
    Carries[length] = int(AddnSub)

    if AddnSub == '1':
        B_String = ''.join('1' if b == '0' else '0' for b in B_String)  # Flip bits of B

    for i in range(length-1,31,-1):
        A_i = int( A_String[i] )
        B_i = int( B_String[i] )
        C_i = int( Carries[i+1] ) 
        Suum = A_i ^ B_i ^ C_i
        Cout = ( A_i & B_i ) | ( C_i & (A_i ^ B_i))
        Sums[i] = Suum
        Carries[i] = Cout
    for i in range(32):
        Sums[i] = Sums[32]
    #print(f"Operands: {A_String} + {B_String} + {Cin}, Expected Sum: {Sums}, Expected Cout: {Carries[0]}, Expected Ovfl: {Carries[0]  ^ Carries[1]}")

    #return A+B+Cin, Cout, Ovfl
    return Sums

def SLT(length: int, A_String, B_String):

    Carries = [0]*(length+1)
    Sums = [0]*length
    Carries[length] = 1

    B_String = ''.join('1' if b == '0' else '0' for b in B_String)  # Flip bits of B

    for i in range(length-1,-1,-1):
        A_i = int( A_String[i] )
        B_i = int( B_String[i] )
        C_i = int( Carries[i+1] ) 
        Suum = A_i ^ B_i ^ C_i
        Cout = ( A_i & B_i ) | ( C_i & (A_i ^ B_i))
        Sums[i] = Suum
        Carries[i] = Cout


    AltBU = 1 if Carries[0] == 0 else 0
    AltB = Sums[0] ^ Carries[0] ^ Carries[1]
    allZero = 1 #if all 0s
    for i in range(len(Sums)):
        if Sums[i] == 1:
            allZero = 0
            break

    return AltB, AltBU, allZero

def arr_to_string(x: list):
    st=""
    for i in range(len(x)):
        st += (str(x[i]))
    return st

def logicUnit(logicFN: str, A: str, b: str):
    output = [0]*64
    A = int(A, 2)
    B = int(b, 2)
    result = 0
    # LUI
    if logicFN == "00":
        for i in range(32):
            output[i] = b[32]
        for i in range(32,52):
            output[i] = b[i]
        for i in range(52,64):
            output[i] = '0'
        output = arr_to_string(output)
        result = int(output,2)
        
    # XOR
    elif logicFN == "01":
        result = A ^ B
    # OR
    elif logicFN == "10":
        result = A | B
    # AND
    elif logicFN == "11":
        result = A & B
    return bin(result & 0xFFFFFFFFFFFFFFFF)

def stringToInt(B):
    total = 0
    n = len(B)
    for i in range(n):
        total += int(B[i]) * 2**(n - i - 1)
    return total


def SLL(A: str, shamt: int, ExtWord: int) -> str:
    """
    Logical left shift.
    If ExtWord is 1, performs SLLW (32-bit operation).
    """
    output = ["0"]*64
    if ExtWord == '1':
        #shamt %= 32
        for i in range(32,64-shamt):
            output[i] = A[i + shamt]
        for i in range(64-shamt, 64):
            output[i] = 0
        for i in range(32):
            #print(shamt)
            output[i] = output[32]
        return arr_to_string(output)
    
    else:
        # Standard 64-bit operation
        for i in range(64-shamt):
            output[i] = A[i+shamt]
        for i in range(64-shamt, 64):
            output[i] = 0 
        return arr_to_string(output)

def SRL(A: str, shamt: int, ExtWord: int) -> str:
    """
    Logical right shift.
    If ExtWord is 1, performs SRLW (32-bit operation).
    """
    output = ["0"]*64
    if ExtWord == '1':
        for i in range(32+shamt, 64):
            output[i] = A[i - shamt]
        for i in range(32+shamt):
            output[i] = '0'

        return arr_to_string(output)  # Perform shift and append zeros to the right
    else:
        # Standard 64-bit operation
        for i in range(shamt, 64):
            output[i] = A[i-shamt]
        for i in range(0,shamt):
            output[i] = '0'
        return arr_to_string(output)

def SRA(A: str, shamt: int, ExtWord: int) -> str:
    output = ["0"]*64
    if ExtWord == '1':
        for i in range(32+shamt, 64):
            output[i] = A[i - shamt]
        for i in range(32+shamt):
            output[i] = A[32]

        return arr_to_string(output)  
    
    else:
        # Standard 64-bit operation
        for i in range(shamt, 64):
            output[i] = A[i-shamt]
        for i in range(0,shamt):
            output[i] = A[0]
        return arr_to_string(output)

length = 64


with open("Exec00.tvs", "w") as file:
    for vecNum in range(120):


        if vecNum < 50:
            FuncClass = '00' #00 = for shift/arith, 01 for logic, 10 for slt, 11 for sltu
            LogicFN = ''.join(random.choice('01') for _ in range(2)) #00 for lui, 01 xor, 10 or, 11 and
            ShiftFN = ''.join(random.choice('01') for _ in range(2)) #00 arith, 01 sll, 10  srl, 11 sra
            AddnSub =  random.choice('01')
            ExtWord = random.choice('01')
            A_String = ''.join(random.choice('01') for _ in range(64))
            B_String = ''.join(random.choice('01') for _ in range(64))

        if 50 <= vecNum < 100:
            FuncClass = '01' #00 = for shift/arith, 01 for logic, 10 for slt, 11 for sltu
            LogicFN = ''.join(random.choice('01') for _ in range(2)) #00 for lui, 01 xor, 10 or, 11 and
            ShiftFN = ''.join(random.choice('01') for _ in range(2)) #00 arith, 01 sll, 10  srl, 11 sra
            AddnSub =  random.choice('01')
            ExtWord = random.choice('01')
            A_String = ''.join(random.choice('01') for _ in range(64))
            B_String = ''.join(random.choice('01') for _ in range(64))   

        if 100 <= vecNum < 110:
            FuncClass = '10' #00 = for shift/arith, 01 for logic, 10 for slt, 11 for sltu
            LogicFN = ''.join(random.choice('01') for _ in range(2)) #00 for lui, 01 xor, 10 or, 11 and
            ShiftFN = ''.join(random.choice('01') for _ in range(2)) #00 arith, 01 sll, 10  srl, 11 sra
            AddnSub =  random.choice('01')
            ExtWord = random.choice('01')
            A_String = ''.join(random.choice('01') for _ in range(64))
            B_String = ''.join(random.choice('01') for _ in range(64))    

        if vecNum >= 110:
            FuncClass = '11' #00 = for shift/arith, 01 for logic, 10 for slt, 11 for sltu
            LogicFN = ''.join(random.choice('01') for _ in range(2)) #00 for lui, 01 xor, 10 or, 11 and
            ShiftFN = ''.join(random.choice('01') for _ in range(2)) #00 arith, 01 sll, 10  srl, 11 sra
            AddnSub =  random.choice('01')
            ExtWord = random.choice('01')
            A_String = ''.join(random.choice('01') for _ in range(64))
            B_String = ''.join(random.choice('01') for _ in range(64))    

        A = int(A_String,2)
        B = int(B_String,2)
        lui = False
        if FuncClass == '10' or FuncClass == '11':
            AddnSub = '1'


        #Make it a SextU if LUI is chosen
        if FuncClass == '01' and LogicFN == '00':
            lui = True
            B = (B & 0x00000000000FFFFF) << 12 #take the 20 bits
            B_String_For_Lui = bin(B)[2:].zfill(64)
            #B_String_For_Lui = B_String_For_Lui.zfill(64)
            #print(B_String_For_Lui)
            #print(hex(int(B_String_For_Lui,2)))
            #print("here")
        else:
            B_String_For_Lui = B_String

        if lui:
            B_String = B_String_For_Lui

        #ARITH OUT
        Sum, Cout, Ovfl = add_sub(length, AddnSub, A_String, B_String) #SUM IS AN ARRAY #for Add, sub
        Sum32 =  add_sub_word(length, AddnSub, A_String, B_String) #SUM IN AN ARRAY for addw, subw
        Sum = arr_to_string(Sum)
        Sum32 = arr_to_string(Sum32)
        Cout = str(Cout)
        Ovfl = str(Ovfl)

        #CONTROL SIGNALS FROM ARITH
        AltB, AltBU, allZero = SLT(64,A_String, B_String) #THESE ARE (INT) 0 OR 1 
        AltB = str(AltB)
        AltBU = str(AltBU)
        allZero = str(allZero)

        #LOGICFN
        LogicOut = logicUnit(LogicFN, A_String, B_String_For_Lui) #THIS OUTPUT IS A STRING

        #SHIFTFN
        if ExtWord == '1':
            shamt = B & 0x000000000000001F #MASK SHAMT TO ONLY 5 BITS
            #print(shamt, hex(B))
        else:
            shamt = B & 0x000000000000003F
        A_SLL = SLL(A_String, shamt, ExtWord) #THIS IS A STRING
        A_SRL = SRL(A_String, shamt, ExtWord) #THIS IS A STRING
        A_SRA = SRA(A_String, shamt, ExtWord) #THIS IS A STRING



        A_HEX = hex(int(A_String,2))
        B_HEX = hex(int(B_String,2))
        

        if ExtWord == '0':
            if ShiftFN == '00':
                intermediate = Sum
            elif ShiftFN == '01':
                intermediate = A_SLL
            elif ShiftFN == '10':
                intermediate = A_SRL
            elif ShiftFN == '11':
                intermediate = A_SRA
            else:
                print("Something very wrong")

        elif ExtWord == '1':
            if ShiftFN == '00':
                intermediate = Sum32
            elif ShiftFN == '01':
                intermediate = A_SLL
            elif ShiftFN == '10':
                intermediate = A_SRL
            elif ShiftFN == '11':
                intermediate = A_SRA
            else:
                print("Something very wrong")

        if FuncClass == '00':
            Y = intermediate
        elif FuncClass == '01':
            Y  = LogicOut
        elif FuncClass == '10':
            Y = AltB
        elif FuncClass == '11':
            Y = AltBU

        A_HEX = hex(A)[2:].zfill(16)  # Hex output, padding with zeroes for 64-bits
        B_HEX = hex(B)[2:].zfill(16)
        Y_int = int(Y,2)
        Y_HEX = hex(Y_int)[2:].zfill(16)

        file.write(f"{A_HEX} {B_HEX} {FuncClass} {LogicFN} {ShiftFN} {AddnSub} {ExtWord} {Y_HEX} {allZero} {AltB} {AltBU}\n")

### A, B, FuncClass, LogicFN, ShiftFN, AddnSub, ExtWord, Y, Zero, AltB, AltBu






# -*- coding: utf-8 -*-
"""
Created on Mon Sep 25 19:36:36 2017

@author: anders
"""

'''
620031587
Net-Centric Computing Assignment
Part A - RSA Encryption
'''

import random
from datetime import datetime

'''
Euclid's algorithm for determining the greatest common divisor
Use iteration to make it faster for larger integers
'''
def gcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a

'''
Euclid's extended algorithm for finding the multiplicative inverse of two numbers
'''
def multiplicative_inverse(e, phi):
    d = 0
    x1 = 0
    x2 = 1
    y1 = 1
    temp_phi = phi

    while e > 0:
        temp1 = temp_phi/e
        temp2 = temp_phi - temp1 * e
        temp_phi = e
        e = temp2

        x = x2- temp1* x1
        y = d - temp1 * y1

        x2 = x1
        x1 = x
        d = y1
        y1 = y

    if temp_phi == 1:
        return d + phi

'''
Tests to see if a number is prime.
'''
def is_prime(num):
    if num == 2:
        return True
    if num < 2 or num % 2 == 0:
        return False
    for n in xrange(3, int(num**0.5)+2, 2):
        if num % n == 0:
            return False
    return True

def generate_keypair(p, q):
    if not (is_prime(p) and is_prime(q)):
        raise ValueError('Both numbers must be prime.')
    elif p == q:
        raise ValueError('p and q cannot be equal')
    #n = pq
    n = p * q

    #Phi is the totient of n
    phi = (p-1) * (q-1)

    #Choose an integer e such that e and phi(n) are coprime
    e = random.randrange(1, phi)

    #Use Euclid's Algorithm to verify that e and phi(n) are comprime
    g = gcd(e, phi)
    while g != 1:
        e = random.randrange(1, phi)
        g = gcd(e, phi)

    #Use Extended Euclid's Algorithm to generate the private key
    d = multiplicative_inverse(e, phi)

    #Return public and private keypair
    #Public key is (e, n) and private key is (d, n)
    return ((e, n), (d, n))

def MonPro(a_strek, b_strek, n, n_merket, r):
    #print(a_strek, b_strek)
    t = a_strek * b_strek
    m = (t * n_merket) % r
    u = (t+(m*n))/r
#    print(a_strek, b_strek, "u:", u)
    if u >= n:
#        print "more",u-n
        return u-n
#    print u
    return u

def BinExp(message, e, n):
    k = 0
    ebin = str(bin(e))[2:]
    if len(ebin) == 1:
        C = message
        return C
    for k in range (len(ebin)-1, -1, -1):
        if k == len(ebin)-1:        
            if ebin[k-1] == 1:
                C = message
            else:
                C = 1
        for i in range(k-2, -1, -1):
            if ebin[i] == 1:
                C = C * message % n
            else:
                C = C * C % n
    return C

def ModInverse(invvar, j):
   y = 1
   for i in range (2, j+1):
       if (2 ** (i-1)) < ((invvar*y) % 2**i):
           y+=2**(i-1)
       else:
           y=y
   return y


def BinSplit(n):
    binsend = []
    binnum = str(bin(n))[2:]
    n_place = 0
    n_count = len(binnum)-1
    while n_place == 0:
        if binnum[n_count] > 0:
            n_place = n_count
        else:
            n_count -= 1
    binodd = binnum[:n_place]
    bineven = binnum[n_place:]
    binsend.append(len(bineven))
    binsend.append(int(binodd,2))
    return binsend

def extended_gcd(a,b):  
    t = 1; oldt = 0
    r = b; oldr = a
    while r != 0:
        quotient = oldr / r
        (oldr, r) = (r, oldr - quotient*r)
        (oldt, t) = (t, oldt - quotient*t)
    return oldt

def ModExp(message, e, n):
    #Calculate r
    i = 0
    while (2 ** i) < n:
        i += 1

    r = 2 ** i

        
    n_merket = -extended_gcd(r,n)
    e_bit = bin(e)[2:]
    #Calculate M_strek
    M_strek = (message * r) % n
    

    #Calculate x_strek
    x_strek = r % n

#        print e, "=", e_bit,"Melding:",message
    for i in e_bit:
        x_strek = MonPro(x_strek,x_strek,n,n_merket,r)
#            print "i:",i
        if i == '1':
#            print "match"
            x_strek = MonPro(M_strek,x_strek,n,n_merket,r)

    x = MonPro(x_strek,1,n,n_merket,r)

    return x



def torge_crypt(pk, M):
    
    binret=[]    
    #Unpack the key into it's components
    e, n = pk

    if n % 2 == 0:
        binret=BinSplit(n)
        j = binret[0]
        q = binret[1]
        x1 = ModExp(message, e, q)
        x2val = 2**j
        x2_1 = message % x2val
        x2_2 = e % 2**(j-1)
        x2 = BinExp(x2_1, x2_2, x2val)
        q_inv = ModInverse(q,j)
        y = (x2 - x1)*q_inv % x2val
        x = x1 + q*y
        return x
        
    else:    
        return ModExp(M, e, n)


if __name__ == '__main__':
    '''
    Detect if the script is being run directly by the user
    '''
    print "RSA Encrypter/ Decrypter"
    p = int(raw_input("Enter a prime number (17, 19, 23, etc): "))
    q = int(raw_input("Enter another prime number (Not one you entered above): "))
#    p = 43
#    q = 17
#    message = 19
    
    print "Generating your public/private keypairs now . . ."
    public, private = generate_keypair(p, q)
    print "Your public key is ", public ," and your private key is ", private
    print "Enter a number to encrypt with your private key: "
    print_string = "Needs to be less then " + str(private[1])+": "
    message_str = raw_input(print_string)

    message = int(message_str)


#    private = (10,13)
#    private = (5,119)
#    public = (77,119)

    print "Message is:", message
    print "encrypting message with private key", private, ". . ."
    startTime = datetime.now()
    encrypted_msg = torge_crypt(private, message)
    print "Kryptert:",encrypted_msg
    print "Decrypting message with public key ", public ," . . ."
    decrypted_msg = torge_crypt(public, encrypted_msg)
    print "Dekryptert", decrypted_msg
    print "Tid:", datetime.now() - startTime
    print ""
    print "Fasit"
    print ""
#    Fasit_encrypted_msg = (message ** private[0]) % private[1]
#    print Fasit_encrypted_msg
#    Fasit_decrypted_msg = (Fasit_encrypted_msg ** public[0]) % public[1]
#    print Fasit_decrypted_msg
#
#    print ""
#    if encrypted_msg == Fasit_encrypted_msg and decrypted_msg == Fasit_decrypted_msg:
#        print "Woohooo, all pass!!"
#    else:
#        print "Buuhuu, noe gikk galt"








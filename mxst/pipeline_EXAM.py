# -*- coding: utf-8 -*-
"""
Created on Mon Jun 29 08:58:00 2020

@author: simon

SEE EXAM in the SECTION BELOW

"""
#%%
import sympy as sp
import numpy as np
import matplotlib.pyplot as plt

# Quantizer
# quant(0.111, [-0.125, 0.125]) ==> 1 out of range[0, 1, 2]
# returns value in range [0 to n+1] where n = len(references)
def quant(x, thresholds): 
   t = np.concatenate( ( thresholds, [1e10] ) ) 
   r = min( [(idx,val) for (idx,val) in enumerate(t) if val>x] )[0] 
   return r

# MDAC
# mdac(0.123, [-0.125, 0.125], [-0.25, 0, 0.25], 2) ==> [1, 0.246]
#
# thresholds => for quantizer
# reference  => for DAC
def mdac(x, thresholds, references, gain): 
   # The MDAC first uses a quantizer to determine the region. 
   r = quant(x,thresholds) 
   y = ( x - references[r] ) * gain 
   return [r,y]
    
# pipeline ADC
def pipeA(x, Nstage): 
   re15 = np.arange( -1/4, 1/4+0.01, 1/4 ) 
   th15 = np.convolve( re15, np.array([1/2,1/2]) )[1:-1] 
   ga15 = 2
   xs = np.zeros(Nstage) 
   xs[0] = x 
   rs = np.zeros(Nstage) 
   cumgain = 1 
   
   # All but the last stage are 1.5-bit-stages: 
   for k in np.arange(Nstage-1): 
       # Use the appropriate MDAC: 
       [rs[k],xs[k+1]] = mdac(xs[k],th15,re15,ga15) 
       # The cumulative gain is  multiplied by the gain of the stage: 
       cumgain *= 2 
       # The region is then scaled by 1/cumgain; therefore the first stage 
       # just ouputs its region number divided by its gain. 
       rs[k] = rs[k]/cumgain 
   
   # The last stage is a normal 1-bit stage with a gain of 1
   k=Nstage-1 
   rs[k] = quant(xs[k],[0]) 
   cumgain = cumgain*1 
   rs[k] = rs[k]/cumgain 
   
   # The output of the ADC is the sum of all region numbers, but if we want 
   # integers, they need to be scaled back by cumgain. 
   b = np.sum(rs)*cumgain 
   return b

# 1.5 Bit
def pipeAnonid(x, Nstage): 
   # This is the same as pipeA, but with an incorrect gain and a shifted 
   # reference: 
   re15 = np.arange( -1/4, 1/4+0.01, 1/4 ) 
   th15 = np.convolve( re15, np.array([1/2,1/2]) )[1:-1] 
   # ------  INPUT HERE  ------
   ga15 = 1.98 
   re15[0] = re15[0]-0.01 
   # ------ 
   xs = np.zeros(Nstage) 
   xs[0] = x 
   rs = np.zeros(Nstage) 
   cumgain = 1 
   for k in np.arange(Nstage-1): 
       [rs[k],xs[k+1]] = mdac(xs[k],th15,re15,ga15) 
       cumgain *= 2 
       rs[k] = rs[k]/cumgain 
   # last stage
   k=Nstage-1 
   rs[k] = quant(xs[k],[0]) 
   cumgain = cumgain*1 
   rs[k] = rs[k]/cumgain 
   # output scale 
   b = np.sum(rs)*cumgain 
   return b

# 1.5 Bit
def pipe1721(x,Nstage): 
   # This is the ADC from Fig. 17.21 in the textbook; the only difference is that 
   # the last stage is a two-bit quantizer 
   re15 = np.arange( -1/4, 1/4+0.01, 1/4 ) 
   th15 = np.convolve( re15, np.array([1/2,1/2]) )[1:-1] 
   ga15 = 2 
   xs = np.zeros(Nstage) 
   xs[0] = x 
   rs = np.zeros(Nstage) 
   cumgain = 1 
   for k in np.arange(Nstage-1): 
       [rs[k],xs[k+1]] = mdac(xs[k],th15,re15,ga15) 
       cumgain *= 2 
       rs[k] = rs[k]/cumgain 
   k=Nstage-1 
   
   # The last stage is a two-bit stage. 
   # This two-bit stage needs to have one threshold at 0! 
   # Being a two-bit stage, it implicitly has a gain of 2 
   rs[k] = quant(xs[k],[-0.5,0,0.5]) 
   cumgain = cumgain*2 
   rs[k] = rs[k]/cumgain 
   
   # output scale 
   b = np.sum(rs)*cumgain 
   return b

# 1.5 Bit - Nonideal
def pipe1721nonid(x,Nstage): 
   # This is the ADC from Fig. 17.21 in the textbook; the only difference is that 
   # the last stage is a two-bit quantizer 
   re15 = np.arange( -1/4, 1/4+0.01, 1/4 ) 
   th15 = np.convolve( re15, np.array([1/2,1/2]) )[1:-1]
   # ------  INPUT HERE  ------
   ga15 = 1.98 
   re15[0] = re15[0]-0.01 
   # ------ 
   xs = np.zeros(Nstage) 
   xs[0] = x 
   rs = np.zeros(Nstage) 
   cumgain = 1 
   for k in np.arange(Nstage-1): 
       [rs[k],xs[k+1]] = mdac(xs[k],th15,re15,ga15) 
       cumgain *= 2 
       rs[k] = rs[k]/cumgain 
   k=Nstage-1 
   
   # The last stage is a two-bit stage. 
   # This two-bit stage needs to have one threshold at 0! 
   # Being a two-bit stage, it implicitly has a gain of 2 
   rs[k] = quant(xs[k],[-0.5,0,0.5]) 
   cumgain = cumgain*2 
   rs[k] = rs[k]/cumgain 
   
   # output scale 
   b = np.sum(rs)*cumgain 
   return b

# 2.5 Bit Stages followed by 1.5 Bit Stages and a final 1 Bit stage
def pipe25b15b(x,N25,N15): 
   # This is again the same as pipeA, but it has N25 2.5-bit stages followed 
   # by N15 1.5-bit stages and one 1-bit stage. 
   re15 = np.arange( -1/4, 1/4+0.01, 1/4 ) 
   th15 = np.convolve( re15, np.array([1/2,1/2]) )[1:-1] 
   ga15 = 2 
   
   # So we also need the thresholds and gains of the 2.5-bit MDAC: 
   re25 = np.arange( -6/16, 6/16+0.01, 1/8 ) 
   th25 = np.convolve( re25, np.array([1/2,1/2]) )[1:-1] 
   ga25 = 4 

   # The total number of stages is now 
   Nstage = N25+N15+1 

   xs = np.zeros(Nstage) 
   xs[0] = x 
   rs = np.zeros(Nstage) 
   cumgain = 1 

   # First the 2.5-bit stages. 
   for k in np.arange(N25): 
       [rs[k],xs[k+1]] = mdac(xs[k],th25,re25,ga25) 
       cumgain *= 4 
       rs[k] = rs[k]/cumgain 

   # Then the 1.5-bit stages: their indices go from N25 to Nstage-1: 
   for k in np.arange(N25,Nstage-1): 
       [rs[k],xs[k+1]] = mdac(xs[k],th15,re15,ga15) 
       cumgain *= 2 
       rs[k] = rs[k]/cumgain 
       
   # We finish with the one-bit stage 
   k=Nstage-1 
   rs[k] = quant(xs[k],[0]) 
   cumgain = cumgain*1 
   rs[k] = rs[k]/cumgain 
   
   # output scale 
   b = np.sum(rs)*cumgain 
   return b

# 2.5 Bit Stages followed by a final 1 Bit stage
def pipe25b(x,N25):    
   # So we also need the thresholds and gains of the 2.5-bit MDAC: 
   re25 = np.arange( -6/16, 6/16+0.01, 1/8 ) 
   th25 = np.convolve( re25, np.array([1/2,1/2]) )[1:-1] 
   ga25 = 4 

   # The total number of stages is now 
   Nstage = N25+1

   xs = np.zeros(Nstage) 
   xs[0] = x 
   rs = np.zeros(Nstage) 
   cumgain = 1 

   # First the 2.5-bit stages. 
   for k in np.arange(N25): 
       [rs[k],xs[k+1]] = mdac(xs[k],th25,re25,ga25)
       cumgain *= 4 
       rs[k] = rs[k]/cumgain 
       
   # We finish with the one-bit stage 
   k=Nstage-1 
   rs[k] = quant(xs[k],[0]) 
   cumgain = cumgain*1 
   rs[k] = rs[k]/cumgain 
   
   # output scale 
   b = np.sum(rs)*cumgain 
   return b

# 2.5 Bit Stages followed by a final 1 Bit stage
def pipe25bNonid(x,N25):     
   eps = 0.07  # comparator offset
   
   # So we also need the thresholds and gains of the 2.5-bit MDAC: 
   re25 = np.arange( -6/16, 6/16+0.01, 1/8 ) 
   th25 = np.convolve( re25, np.array([1/2,1/2]) )[1:-1] 
   ga25 = 4.0
   
   th25 = th25 + eps

   # The total number of stages is now 
   Nstage = N25+1

   xs = np.zeros(Nstage) 
   xs[0] = x 
   rs = np.zeros(Nstage) 
   cumgain = 1 

   # First the 2.5-bit stages. 
   for k in np.arange(N25): 
       [rs[k],xs[k+1]] = mdac(xs[k],th25,re25,ga25)
       cumgain *= 4 
       rs[k] = rs[k]/cumgain 
       
   # We finish with the one-bit stage 
   k=Nstage-1 
   rs[k] = quant(xs[k],[0]) 
   cumgain = cumgain*1 
   rs[k] = rs[k]/cumgain 
   
   # output scale 
   b = np.sum(rs)*cumgain 
   return b

# 2.5 Bit Stages followed by a final 1 Bit stage
# Nonid - by Simon
def pipe25bNonid_vs(x,N25, offset):
   eps = offset  # threshold offset
   re25 = np.arange( -6/16, 6/16+0.01, 1/8 ) 
   th25 = np.convolve( re25, np.array([1/2,1/2]) )[1:-1] 
   ga25 = 4.0
   # ------  INPUT HERE  ------
   th25[3] = th25[3] + eps
   # ------
   # The total number of stages is now 
   Nstage = N25+1

   xs = np.zeros(Nstage) 
   xs[0] = x 
   rs = np.zeros(Nstage) 
   cumgain = 1 

   # First the 2.5-bit stages. 
   for k in np.arange(N25): 
       [rs[k],xs[k+1]] = mdac(xs[k],th25,re25,ga25)
       cumgain *= 4 
       rs[k] = rs[k]/cumgain 
       
   # We finish with the one-bit stage 
   k=Nstage-1 
   rs[k] = quant(xs[k],[0]) 
   cumgain = cumgain*1 
   rs[k] = rs[k]/cumgain 
   
   # output scale 
   b = np.sum(rs)*cumgain 
   return b

# DAC 
# dacA(0, 16)      = -0.49999237060546875
# dacA(0, 2**16-1) = 0.5
def dacA(b, Nbit): 
   # This is the correct DAC for an ideal Nbit ADC 
   # The full range is 2**Nbit steps, 0 is -0.5+LSB/2, 15 is +0.5-LSB/2, so: 
   y = -0.5 + b/2**Nbit + 1/2**(Nbit+1) 
   return y   

def pipe35(x, Nstage):
   re35 = np.arange(  -14/32 , 14/32+0.01, 1/16 )
   th35 = np.convolve(re35, np.array([1/2,1/2]) )[1:-1] 
   ga35 = 8
    
   xs = np.zeros(Nstage) 
   xs[0] = x 
   rs = np.zeros(Nstage) 
   cumgain = 1 
   # All but the last stage are 1.5-bit-stages: 
   for k in np.arange(Nstage-1): 
       # Use the appropriate MDAC: 
       [rs[k],xs[k+1]] = mdac(xs[k],th35,re35,ga35) 
       # The cumulative gain is  multiplied by the gain of the stage: 
       cumgain *= 8
       # The region is then scaled by 1/cumgain; therefore the first stage 
       # just ouputs its region number divided by its gain. 
       rs[k] = rs[k]/cumgain 
   
   # The last stage is a normal 1-bit stage with a gain of 1
   k=Nstage-1 
   rs[k] = quant(xs[k],[0]) 
   cumgain = cumgain*1 
   rs[k] = rs[k]/cumgain 
   
   # The output of the ADC is the sum of all region numbers, but if we want 
   # integers, they need to be scaled back by cumgain. 
   b = np.sum(rs)*cumgain 
   return b

def pipe35Nonid(x, Nstage):
   re35 = np.arange(  -14/32 , 14/32+0.01, 1/16 )
   th35 = np.convolve(re35, np.array([1/2,1/2]) )[1:-1] 
   ga35 = 8
   th35[4] += 1/32*1.1
    
   xs = np.zeros(Nstage) 
   xs[0] = x 
   rs = np.zeros(Nstage) 
   cumgain = 1 
   # All but the last stage are 1.5-bit-stages: 
   for k in np.arange(Nstage-1): 
       # Use the appropriate MDAC: 
       [rs[k],xs[k+1]] = mdac(xs[k],th35,re35,ga35) 
       # The cumulative gain is  multiplied by the gain of the stage: 
       cumgain *= 8
       # The region is then scaled by 1/cumgain; therefore the first stage 
       # just ouputs its region number divided by its gain. 
       rs[k] = rs[k]/cumgain 
   
   # The last stage is a normal 1-bit stage with a gain of 1
   k=Nstage-1 
   rs[k] = quant(xs[k],[0]) 
   cumgain = cumgain*1 
   rs[k] = rs[k]/cumgain 
   
   # The output of the ADC is the sum of all region numbers, but if we want 
   # integers, they need to be scaled back by cumgain. 
   b = np.sum(rs)*cumgain 
   return b
    

#%% EXAM QUESTIONS BELOW

#%%
# Test 3.5Bit MDAC

eps = 0.04 # comparator offset

re35 = np.arange(  -14/32 , 14/32+0.01, 1/16 )
th35 = np.convolve(re35, np.array([1/2,1/2]) )[1:-1] 
ga35 = 8
   
vi = np.arange(0,1.0001,0.0001)-0.5
mo = np.array( [ mdac(x,th35,re35,ga35) for x in vi] ) 

fig,ax1 = plt.subplots()
pcolor = 'tab:red'
ax1.set_title('Figure 17.20 - a 1.5-bit pipelined converter stage')
ax1.set_xlabel('MDAC input voltage')
ax1.set_ylabel('MDAC digital value', color=pcolor)
ax1.plot(vi, mo[:,0], color=pcolor)
ax1.tick_params(axis='y', labelcolor=pcolor) 
ax1.grid(axis='x')

ax2 = ax1.twinx()
pcolor = 'tab:blue'
ax2.set_ylabel('MDAC output voltage', color=pcolor)  # we already handled the x-label with ax1
ax2.plot(vi, mo[:,1], color=pcolor)
ax2.tick_params(axis='y', labelcolor=pcolor)
ax2.grid()

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()

#%%
# Test 3.5Bit MDAC - NONIDEAL - with offset

offs = 2/32*0.9 # comparator offset
# 10% less offset has still a monotonic behaviour
offs = 2/32
# 2/32 offset produces missing codes <== Indicator for offset too large

re35 = np.arange(  -14/32 , 14/32+0.01, 1/16 )
th35 = np.convolve(re35, np.array([1/2,1/2]) )[1:-1] 
ga35 = 8
th35[5] = th35[5] + offs
   
vi = np.arange(0,1.0001,0.0001)-0.5
mo = np.array( [ mdac(x,th35,re35,ga35) for x in vi] ) 

fig,ax1 = plt.subplots()
pcolor = 'tab:red'
ax1.set_title('Figure 17.20 - a 1.5-bit pipelined converter stage')
ax1.set_xlabel('MDAC input voltage')
ax1.set_ylabel('MDAC digital value', color=pcolor)
ax1.plot(vi, mo[:,0], color=pcolor)
ax1.tick_params(axis='y', labelcolor=pcolor) 
ax1.grid(axis='x')

ax2 = ax1.twinx()
pcolor = 'tab:blue'
ax2.set_ylabel('MDAC output voltage', color=pcolor)  # we already handled the x-label with ax1
ax2.plot(vi, mo[:,1], color=pcolor)
ax2.tick_params(axis='y', labelcolor=pcolor)
ax2.grid()

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()



#%%
# compare 3.5 bit ADC with one that has offset
# does not work. some gain is wrong

Nbits = 13
Nstages = 4

vi = np.arange(0,1.0001,0.0001)-0.5 

ro = np.array([ pipe35(x,Nstages) for x in vi ])
vo = np.array( [ dacA(b,Nbits) for b in ro ] )

roni = np.array([ pipe35Nonid(x,Nstages) for x in vi ])
voni = np.array( [ dacA(b,Nbits) for b in roni ] )

# Diagnostic output
print('This is a %d-bit converter.'%(Nbits))
print('The five smallest an five largest numbers in the output vector are:')
print(np.unique(ro)[[0,1,2,3,4,-5,-4,-3,-2,-1]] )
print('If all is well, these numbers should be bounded by',([0,2**Nbits-1])) 
print(np.unique(roni)[[0,1,2,3,4,-5,-4,-3,-2,-1]] )
print('If all is well, these numbers should be bounded by',([0,2**Nbits-1])) 

fig,ax1 = plt.subplots()

pcolor = 'tab:orange'
ax1.plot(vi, vo, color=pcolor)
pcolor = 'tab:red'
ax1.set_xlabel('ADC input voltage')
ax1.set_ylabel('ADC input and DAC ouput voltage', color=pcolor)
ax1.plot(vi, vi, color=pcolor)
ax1.plot(vi, voni, color=pcolor) 
ax1.tick_params(axis='y', labelcolor=pcolor) 

ax2 = ax1.twinx()
pcolor = 'tab:cyan'
ax2.plot(vi, (voni-vi)*2**Nbits, color=pcolor)
pcolor = 'tab:blue'
ax2.set_ylabel('Quantization error in LSB', color=pcolor)  # we already handled the x-label with ax1
ax2.plot(vi, (voni-vi)*2**Nbits, color=pcolor)
ax2.tick_params(axis='y', labelcolor=pcolor)
ax2.set_ylim(-8,8) 
plt.grid()

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()

#%%
# use 6 x 2.5bit instead
# I still don't see anything happening even with large offsets
# plotting wrong?

offset = 8/16
Nbits = 13  # only odd numbers
N25 = int((Nbits-1)/2)

vi = np.arange(0,1.0001,0.0001)-0.5 

ro25 = np.array( [ pipe25b(x,N25) for x in vi ] ) 
vo25 = np.array( [ dacA(b,Nbits) for b in ro25 ] ) 

# NONIDEAL
ro25ni = np.array( [ pipe25bNonid_vs(x,N25,offset) for x in vi ] ) 
vo25ni = np.array( [ dacA(b,Nbits) for b in ro25 ] ) 

# Diagnostic output
print('This is a %d-bit converter.'%(Nbits))
print('The five smallest an five largest numbers in the output vector are:')
print(np.unique(ro25)[[0,1,2,3,4,-5,-4,-3,-2,-1]] )
print('If all is well, these numbers should be bounded by',([0,2**Nbits-1])) 
print(np.unique(ro25ni)[[0,1,2,3,4,-5,-4,-3,-2,-1]] )
print('If all is well, these numbers should be bounded by',([0,2**Nbits-1])) 

fig,ax1 = plt.subplots()

pcolor = 'tab:orange'
ax1.plot(vi, vo25, color=pcolor)
pcolor = 'tab:red'
ax1.set_xlabel('ADC input voltage')
ax1.set_ylabel('ADC input and DAC ouput voltage', color=pcolor)
ax1.plot(vi, vi, color=pcolor)
ax1.plot(vi, vo25ni, color=pcolor) 
ax1.tick_params(axis='y', labelcolor=pcolor) 

ax2 = ax1.twinx()
pcolor = 'tab:cyan'
ax2.plot(vi, (vo25ni-vi)*2**Nbits, color=pcolor)
pcolor = 'tab:blue'
ax2.set_ylabel('Quantization error in LSB', color=pcolor)  # we already handled the x-label with ax1
ax2.plot(vi, (vo25ni-vi)*2**Nbits, color=pcolor)
ax2.tick_params(axis='y', labelcolor=pcolor)
ax2.set_ylim(-8,8) 
plt.grid()






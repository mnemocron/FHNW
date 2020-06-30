# -*- coding: utf-8 -*-
"""
Created on Mon Jun 22 08:49:49 2020

@author: simon
"""

#%%
import sympy as sp
import numpy as np
import matplotlib.pyplot as plt

# Quantizer
# quant(0.111, [-0.125, 0.125]) ==> 1  out of range[0, 1, 2]
# returns value in range [0 to n+1] where n = len(references)
def quant(x, thresholds): 
   # Concatenate a very high value to the vector of thresholds such that 
   # the line afterwards does not give empty sets 
   t = np.concatenate( ( thresholds, [1e10] ) ) 
   # The code [(idx,val) for (idx,val) in enumerate(t) if val>x] gives back 
   # all pairs of indices and values for values that are larger than x. 
   # The min() function extracts the (idx,val) pair with the lowest idx. 
   # min()[0] is the just the index. This is our decision region. 
   # Possible values go from 0 to the number of thresholds. 
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
   # It then subtracts the appropriate reference voltage for that region 
   # and scales the result with the MDAC gain. 
   y = ( x - references[r] ) * gain 
   return [r,y]

# pipeline ADC
def pipeA(x, Nstage): 
   # First a simple pipeline ADC with Nstage stages. Nstage-1 are 1.5-bit 
   # stages, the last one is a 1-bit stage for the final decision. 
   
   # np.arange(a,b,d) makes an array filled with numbers from a to b, in 
   # steps of d, but NOT including b. So we add 0.001 to the upper limit such 
   # that it is inlcuded. 
    
   # The result of the liner below is array([-0.25,  0.  ,  0.25]) 
   re15 = np.arange( -1/4, 1/4+0.01, 1/4 ) 
   
   # The thresholds are exactly in the middle of the reference voltages.  
   # The convolution with [1/2,1/2] is a moving average which gives one 
   # element too many at each end of the array. Adressing an array 
   # with a[1:-1] gives all elements except the first and the last. 
   
   # The result of the line below is array([-0.125,  0.125])  
   th15 = np.convolve( re15, np.array([1/2,1/2]) )[1:-1] 
   ga15 = 2
   
   # The vector xs will store the input voltage of each stage: 
   xs = np.zeros(Nstage) 
   xs[0] = x 
   
   # The vector rs will store the region that each stage has determined. 
   # The stage must scale the region such that it is between 0 and 1. 
   rs = np.zeros(Nstage) 

   # The number cumgain is all the gain accumulated after each stage.  
   # The logic behind this is that every time a stage multiplies the 
   # voltage, the following stage is less important by the same  
   # factor. We initialize this number with 1: 
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
   
   # The last stage is a normal 1-bit stage with a gain of 1.  The line 
   # cumgain = cumgain*1 is totally useless, but didactically necessary. 
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

# 1.5 Bit
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
def pipe25bNonid_vs(x,N25, offset):
   eps = offset  # threshold offset
   
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

# 1.5 Bit
def pipe15bNonid_vs(x, Nstage, offset): 
   eps = offset  # threshold offset
   # This is the same as pipeA, but with an incorrect gain and a shifted 
   # reference: 
   re15 = np.arange( -1/4, 1/4+0.01, 1/4 ) 
   th15 = np.convolve( re15, np.array([1/2,1/2]) )[1:-1] 
   # ------  INPUT HERE  ------
   ga15 = 2
   th15 = th15 + eps
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

# DAC 
# dacA(0, 16)      = -0.49999237060546875
# dacA(0, 2**16-1) = 0.5
def dacA(b, Nbit): 
   # This is the correct DAC for an ideal Nbit ADC 
   # The full range is 2**Nbit steps, 0 is -0.5+LSB/2, 15 is +0.5-LSB/2, so: 
   y = -0.5 + b/2**Nbit + 1/2**(Nbit+1) 
   return y   

#%% Block tests

#%%
# what role plays commparator offset in a 1.5bit stage ?
# reproduce Fig. 17.20 b)

eps = 0.04 # comparator offset

re15 = np.arange( -1/4, 1/4+0.01, 1/4 )
th15 = np.convolve( re15, np.array([1/2,1/2]) )[1:-1]
th15[0] = th15[0] - eps
th15[1] = th15[1] + eps
ga15 = 2 
vi = np.arange(0,1.0001,0.0001)-0.5
mo = np.array( [ mdac(x,th15,re15,ga15) for x in vi] ) 

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
# what role plays commparator offset in 2.5bit stages
N25 = 4
Nbits = 2*N25+1 
vi = np.arange(0,1.001,0.001)-0.5 
ro = np.array( [ pipe25bNonid(x,N25) for x in vi ] ) 
vo = np.array( [ dacA(b,Nbits) for b in ro ] ) 

# Diagnostic output
print('This is a %d-bit converter.'%(Nbits))
print('The five smallest an five largest numbers in the output vector are:')
print(np.unique(ro)[[0,1,2,3,4,-5,-4,-3,-2,-1]] )
print('If all is well, these numbers should be bounded by',([0,2**Nbits-1])) 

fig,ax1 = plt.subplots()

pcolor = 'tab:red'
ax1.set_xlabel('ADC input voltage')
ax1.set_ylabel('ADC input and DAC ouput voltage', color=pcolor)
ax1.plot(vi, vi, color=pcolor)
ax1.plot(vi, vo, color=pcolor) 
ax1.tick_params(axis='y', labelcolor=pcolor) 
ax1.grid(axis='x')

ax2 = ax1.twinx()
pcolor = 'tab:blue'
ax2.set_ylabel('Quantization error in LSB', color=pcolor)  # we already handled the x-label with ax1
ax2.plot(vi, (vo-vi)*2**Nbits, color=pcolor)
ax2.tick_params(axis='y', labelcolor=pcolor)
ax2.set_ylim(-8,8) 
plt.grid()

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()

"""
This is a 10-bit converter. 
The five smallest an five largest numbers in the output vector are: 
[0.000e+00 1.000e+00 2.000e+00 3.000e+00 4.000e+00 1.019e+03 1.020e+03 
 1.021e+03 1.022e+03 1.023e+03] 
If all is well, these numbers should be bounded by [0, 1023] 
"""


#%%
# Quantizer
# The quantizer is tested by reproducing Fig. 15.6 in the textbook.

Nbits = 3
thresholds = ( np.arange(2**Nbits-1)+0.5 ) / 2**Nbits
vi = np.arange(0,1.0001,0.0001)
bo = np.array( [ quant(v,thresholds) for v in vi ] )
vo = bo/2**Nbits 

fig,ax1 = plt.subplots()
pcolor = 'tab:red'
ax1.set_title('Figure 15.6 - Ramp Signal')
ax1.set_xlabel('Quantizer input voltage')
ax1.set_ylabel('MDAC digital value', color=pcolor)
ax1.plot(vi, bo, color=pcolor)
ax1.plot(vi, vi*2**Nbits, '--', color=pcolor)
ax1.tick_params(axis='y', labelcolor=pcolor) 
ax1.grid(axis='x')

ax2 = ax1.twinx()
pcolor = 'tab:blue'
ax2.set_ylabel('Quantization error in LSBs', color=pcolor)  # we already handled the x-label with ax1
ax2.plot(vi, (vo-vi)*2**Nbits, color=pcolor)
ax2.tick_params(axis='y', labelcolor=pcolor)
ax2.set_ylim(-0.6,0.6)
ax2.grid() 

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()


#%%
# The 1.5-bit MDAC is tested by reproducing Fig. 17.20 in the textbook.

re15 = np.arange( -1/4, 1/4+0.01, 1/4 )
th15 = np.convolve( re15, np.array([1/2,1/2]) )[1:-1]
ga15 = 2 
vi = np.arange(0,1.0001,0.0001)-0.5
mo = np.array( [ mdac(x,th15,re15,ga15) for x in vi] ) 

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
# The 2.5-bit MDAC is tested by reproducing Fig. P17.20 in the textbook.

re25 = np.arange( -6/16, 6/16+0.01, 1/8 )
th25 = np.convolve( re25, np.array([1/2,1/2]) )[1:-1]
ga25 = 4
vi = np.arange(0,1.0001,0.0001)-0.5
mo = np.array( [ mdac(x,th25,re25,ga25) for x in vi] ) 

fig,ax1 = plt.subplots()
pcolor = 'tab:red'
ax1.set_title('Figure P17.20')
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
ax2.grid(axis='both')

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()

#%%
# Ideal and nonideal versions of pipeA()
# Try different numbers of stages as well as different nonidealities
#
# The Pipeline ADC fits the DAC if, in the ideal form, the quantization
# error curve is the expected sawtooth between -0.5 LSB an 0.5 LSB
# and the digital output contains the correct integers.

Nstage = 7
Nbits = Nstage 
vi = np.arange(0,1.0001,0.0001)-0.5 

ro = np.array( [ pipeA(x,Nstage) for x in vi ] )
vo = np.array( [ dacA(b,Nbits) for b in ro ] )

# NONIDEAL
roni = np.array( [ pipeAnonid(x,Nstage) for x in vi ] ) 
voni = np.array( [ dacA(b,Nbits) for b in roni ] ) 

# Diagnostic output
print('This is a %d-bit converter.'%(Nbits))
print('The five smallest an five largest numbers in the output vector are:')
print(np.unique(ro)[[0,1,2,3,4,-5,-4,-3,-2,-1]] )
print('If all is well, these numbers should be bounded by',([0,2**Nbits-1])) 

fig,ax1 = plt.subplots()

pcolor = 'tab:orange'
ax1.plot(vi, voni, color=pcolor)
pcolor = 'tab:red'
ax1.set_xlabel('ADC input voltage')
ax1.set_ylabel('ADC input and DAC ouput voltage', color=pcolor)
ax1.plot(vi, vi, color=pcolor)
ax1.plot(vi, vo, color=pcolor) 
ax1.tick_params(axis='y', labelcolor=pcolor) 

ax2 = ax1.twinx()
pcolor = 'tab:cyan'
ax2.plot(vi, (voni-vi)*2**Nstage, color=pcolor)
pcolor = 'tab:blue'
ax2.set_ylabel('Quantization error in LSB', color=pcolor)  # we already handled the x-label with ax1
ax2.plot(vi, (vo-vi)*2**Nstage, color=pcolor)
ax2.tick_params(axis='y', labelcolor=pcolor)
ax2.set_ylim(-8,8) 
plt.grid()

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()

#%%
# Try different values for Nstage
Nstage = 3
Nbits = Nstage+1 
vi = np.arange(0,1.001,0.001)-0.5 
ro = np.array( [ pipe1721(x,Nstage) for x in vi ] )
vo = np.array( [ dacA(b,Nbits) for b in ro ] ) 

# Diagnostic output
print('This is a %d-bit converter.'%(Nbits))
print('The five smallest an five largest numbers in the output vector are:')
print(np.unique(ro)[[0,1,2,3,4,-5,-4,-3,-2,-1]] )
print('If all is well, these numbers should be bounded by',([0,2**Nbits-1])) 
fig,ax1 = plt.subplots()

pcolor = 'tab:red'
ax1.set_xlabel('ADC input voltage')
ax1.set_ylabel('ADC input and DAC ouput voltage', color=pcolor)
ax1.plot(vi, vi, '--', color=pcolor)
ax1.plot(vi, vo, color=pcolor) 
ax1.tick_params(axis='y', labelcolor=pcolor) 

ax2 = ax1.twinx()
pcolor = 'tab:blue'
ax2.set_ylabel('Quantization error in LSB', color=pcolor)  # we already handled the x-label with ax1
ax2.plot(vi, (vo-vi)*2**Nbits, color=pcolor)
ax2.tick_params(axis='y', labelcolor=pcolor)
ax2.set_ylim(-8,8) 
plt.grid()
fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()

"""
This is a 4-bit converter. 
The five smallest an five largest numbers in the output vector are: 
[ 1.  2.  3.  4.  5. 11. 12. 13. 14. 15.] 
If all is well, these numbers should be bounded by [0, 15] 
"""

#%%
# Try different values for N25 and N15
N25 = 3
N15 = 3
Nbits = 2*N25+N15+1 
vi = np.arange(0,1.001,0.001)-0.5 
ro = np.array( [ pipe25b15b(x,N25,N15) for x in vi ] ) 
vo = np.array( [ dacA(b,Nbits) for b in ro ] ) 

# Diagnostic output
print('This is a %d-bit converter.'%(Nbits))
print('The five smallest an five largest numbers in the output vector are:')
print(np.unique(ro)[[0,1,2,3,4,-5,-4,-3,-2,-1]] )
print('If all is well, these numbers should be bounded by',([0,2**Nbits-1])) 

fig,ax1 = plt.subplots()

pcolor = 'tab:red'
ax1.set_xlabel('ADC input voltage')
ax1.set_ylabel('ADC input and DAC ouput voltage', color=pcolor)
ax1.plot(vi, vi, color=pcolor)
ax1.plot(vi, vo, color=pcolor) 
ax1.tick_params(axis='y', labelcolor=pcolor) 
ax1.grid(axis='x')

ax2 = ax1.twinx()
pcolor = 'tab:blue'
ax2.set_ylabel('Quantization error in LSB', color=pcolor)  # we already handled the x-label with ax1
ax2.plot(vi, (vo-vi)*2**Nbits, color=pcolor)
ax2.tick_params(axis='y', labelcolor=pcolor)
ax2.set_ylim(-8,8) 
plt.grid()

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()

"""
This is a 10-bit converter. 
The five smallest an five largest numbers in the output vector are: 
[0.000e+00 1.000e+00 2.000e+00 3.000e+00 4.000e+00 1.019e+03 1.020e+03 
 1.021e+03 1.022e+03 1.023e+03] 
If all is well, these numbers should be bounded by [0, 1023] 
"""


#%%
"""

SIMONS STUFF BELOW


"""
#%%
# compare 1.5bit to 2.5bit comparator threshold offset error
# offset < 1/16 no issues
# offset = 2/16 --> 2.5 Bit (dark  blue) makes errors
# offset = 3/16 --> 1.5 Bit (light blue) makes errors too

# 2.5 bit ==> dark  blue / red
# 1.5 bit ==> light blue / orange

offset = 2/16
Nbits = 5  # only odd numbers
N25 = int((Nbits-1)/2)
N15 = Nbits

vi = np.arange(0,1.0001,0.0001)-0.5 

ro15 = np.array( [ pipe15bNonid_vs(x,N15,offset) for x in vi ] )
vo15 = np.array( [ dacA(b,Nbits) for b in ro15 ] )

# NONIDEAL
ro25 = np.array( [ pipe25bNonid_vs(x,N25,offset) for x in vi ] ) 
vo25 = np.array( [ dacA(b,Nbits) for b in ro25 ] ) 

# Diagnostic output
print('This is a %d-bit converter.'%(Nbits))
print('The five smallest an five largest numbers in the output vector are:')
print(np.unique(ro15)[[0,1,2,3,4,-5,-4,-3,-2,-1]] )
print('If all is well, these numbers should be bounded by',([0,2**Nbits-1])) 
print(np.unique(ro25)[[0,1,2,3,4,-5,-4,-3,-2,-1]] )
print('If all is well, these numbers should be bounded by',([0,2**Nbits-1])) 

fig,ax1 = plt.subplots()

pcolor = 'tab:orange'
ax1.plot(vi, vo15, color=pcolor)
pcolor = 'tab:red'
ax1.set_xlabel('ADC input voltage')
ax1.set_ylabel('ADC input and DAC ouput voltage', color=pcolor)
ax1.plot(vi, vi, color=pcolor)
ax1.plot(vi, vo25, color=pcolor) 
ax1.tick_params(axis='y', labelcolor=pcolor) 

ax2 = ax1.twinx()
pcolor = 'tab:cyan'
ax2.plot(vi, (vo15-vi)*2**Nbits, color=pcolor)
pcolor = 'tab:blue'
ax2.set_ylabel('Quantization error in LSB', color=pcolor)  # we already handled the x-label with ax1
ax2.plot(vi, (vo25-vi)*2**Nbits, color=pcolor)
ax2.tick_params(axis='y', labelcolor=pcolor)
ax2.set_ylim(-8,8) 
plt.grid()

fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.show()







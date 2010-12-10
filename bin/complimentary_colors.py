#!/bin/env python
import sys,pygame

if len(sys.argv) < 2:
   print "usage %s <img filename>"%sys.argv[0]
   sys.exit()

ball = pygame.image.load(sys.argv[1])
b = pygame.surfarray.array3d(ball)
red,blue,green,cntr = 0,0,0,0
for i in b:
   for s in i:
      red   += s[0]
      blue  += s[1]
      green += s[2]
      cntr += 1
primary = red/cntr, blue/cntr, green/cntr
secondary = [(i*1.5)%255  for i in primary]
tertiary = [(i*2.0)%255  for i in primary]
print "%s  %s %s"% (
   ''.join([ "%02x"%int(i) for i in primary ]),
   ''.join([ "%02x"%int(i) for i in secondary ]),
   ''.join([ "%02x"%int(i) for i in tertiary ]) 
   )
   

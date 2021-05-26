function [x,DMscore] = diameter_mole(MAL,dpi);
C=25.4;
B=20;
x = ((MAL*C)/(B*dpi));
DMscore=0;
if x<=2
    DMscore=0.5
elseif x<=3 && x>2
    DMscore=1
elseif x<=4 && x>3
    DMscore=1.5
 elseif x<=5 && x>4
    DMscore=2
 elseif x<=6 && x>5
    DMscore=2.5
 elseif x<=7 && x>6
    DMscore=3
 elseif x<=8 && x>7
    DMscore=3.5
 elseif x<=9 && x>8
    DMscore=4
 elseif x<=10 && x>9
    DMscore=4.5
else
    DMscore=5
end
DMscore;

                  
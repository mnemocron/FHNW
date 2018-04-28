function [ans] = stern2dreieck(R1, R2, R3, display)

G1 = 1/R1;
G2 = 1/R2;
G3 = 1/R3;

Ga = (G1*G2)/(G1+G2+G3);
Gb = (G2*G3)/(G1+G2+G3);
Gc = (G1*G3)/(G1+G2+G3);

Ra = 1/Ga;
Rb = 1/Gb;
Rc = 1/Gc;

if(display == true)
	subplot(1, 2, 1);
		r1=rectangle('Position',[1 6 2 0.5]);
	r2=rectangle('Position',[7 6 2 0.5]);
	r3=rectangle('Position',[4.5 3 1 1]);
	
	r1.LineWidth = 3; r2.LineWidth = 3; r3.LineWidth = 3;
	
	l=line([0 1], [6.25 6.25]); l.LineWidth = 3;
	l=line([9 10], [6.25 6.25]); l.LineWidth = 3;
	l=line([3 7], [6.25 6.25]); l.LineWidth = 3;
	l=line([5 5], [6.25 4]); l.LineWidth = 3;
	l=line([5 5], [0 3]); l.LineWidth = 3;
	
	text(1, 7, strcat('R1 = ', num2str(R1), '\Omega'));
	text(6, 7, strcat('R2 = ', num2str(R2), '\Omega'));
	text(6, 3, strcat('R3 = ', num2str(R3), '\Omega'));
	axis([0 10 0 10])
end
%%
if(display == true)
	subplot(1, 2, 2);
	ra=rectangle('Position',[4 6 2 0.5]);
	rb=rectangle('Position',[2 3 1 1]);
	rc=rectangle('Position',[7 3 1 1]);

	ra.LineWidth = 3; rb.LineWidth = 3; rc.LineWidth = 3;
	
	l=line([0 4], [6.25 6.25]); l.LineWidth = 3;
	l=line([6 10], [6.25 6.25]); l.LineWidth = 3;
	l=line([2.5 2.5], [6.25 4]); l.LineWidth = 3;
	l=line([7.5 7.5], [6.25 4]); l.LineWidth = 3;
	l=line([2.5 2.5], [2 3]); l.LineWidth = 3;
	l=line([7.5 7.5], [2 3]); l.LineWidth = 3;
	l=line([2.5 7.5], [2 2]); l.LineWidth = 3;
	l=line([5 5], [0 2]); l.LineWidth = 3;
	
	text(3, 7, strcat('RA = ', num2str(Ra), '\Omega'));
	text(0.3, 1, strcat('RB = ', num2str(Rb), '\Omega'));
	text(5.3, 1, strcat('RC = ', num2str(Rc), '\Omega'));
	
	axis([0 10 0 10]);
end

ans.Ra = Ra;
ans.Rb = Rb;
ans.Rc = Rc;

end



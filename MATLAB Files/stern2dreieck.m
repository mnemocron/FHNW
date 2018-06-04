function [ans] = sternToDreieck(Ra, Rb, Rc, display)

Ga = 1/Ra;
Gb = 1/Rb;
Gc = 1/Rc;

Rnenner = (Ra*Rb + Rb*Rc + Rc*Ra);
Rac = Rnenner / Rb;
Rab = Rnenner / Rc;
Rbc = Rnenner / Ra;

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
	
	text(1, 7, strcat('R_a = ', num2str(Ra), '\Omega'));
	text(6, 7, strcat('R_b = ', num2str(Rb), '\Omega'));
	text(6, 3, strcat('R_c = ', num2str(Rc), '\Omega'));
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
	
	text(3, 7, strcat('R_{ab} = ', num2str(Rab), '\Omega'));
	text(0.3, 1, strcat('R_{ac} = ', num2str(Rac), '\Omega'));
	text(5.3, 1, strcat('R_{bc} = ', num2str(Rbc), '\Omega'));
	
	axis([0 10 0 10]);
end

ans.Rab = Rab;
ans.Rac = Rac;
ans.Rbc = Rbc;

end



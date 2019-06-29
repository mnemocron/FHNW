%******************************************************************************
% Project     : Schlussprüfung Matlab
% Autor       : Vorname Nachname
% Filename    : Endprüfung Version C
% Date        : 11. Mai 2018
%******************************************************************************

%-----------------------------------------------------------------------------
% Vorlage
%-----------------------------------------------------------------------------

clc; clearvars; close all hidden;
%Initalisierungen
f0 = 2;                                     %[Hz] Resonanzfrequenz
d  = 3;                                     %[-] Abklingkoeffizient
Up = 10;                                    %[V] Spannung


t = linspace(0,1.5,1e3);                    %[sec] Zetivektor

%Berechnungen
ut = Up*(1-cos(2*pi*f0*t).*exp(-d*t));      %[V] Zeitverlauf der Spannung
[Umax,IND_Umax]=max(ut);                    %[V] Maximalwert der Spannung   
t_Umax=t(IND_Umax);                         %[V] Zugehöriger Zeitpunkt

uenv = Up*(1+exp(-d*t));                    %[V] positive Umhüllende


%-----------------------------------------------------------------------------
% Aufgabe 1: Plots/Subplots
%-----------------------------------------------------------------------------

% a)Zeichnen Sie Spannung linear in eine Figur. Schalten Sie das Gitternetz ein.
%	Die Linie soll schwarz sein und
%	Eine Liniendicke von 2 aufweisen

plot(t, ut, 'Color',  'black', 'LineWidth', 2)

grid on

% b)Setzen Sie den Titel „Sprungantwort eines gedämpften Schwingkreises“
% 	Ändern Sie die Schriftart auf „Arial“
% 	Mit der Schriftgrösse 14

title("Sprungantwort eines gedämpften Schwingkreises", 'FontName', 'Arial', 'FontSize', 14)

% c)Beschriften Sie die x-Achse mit Zeit [sec]
% 	Beschriften Sie die y-Achse mit uSprung [V] (tiefgestellten Indizes)

xlabel('Zeit [sec]')
ylabel('u_S_p_r_u_n_g [V]')

% d)Setzen Sie die Achsen: x: 0…1.2; y: 0…20

axis([0, 1.2, 0, 20])

% e)Setzen Sie einen roten Kreis beim Punkt (t_Umax, Umax), wobei die
%   gespeicherten Werte zu verwenden sind.

hold on

plot(t_Umax, Umax, 'Marker', "o", 'Color', [1, 0, 0])

hold off

% 	Erstellen eine schwarze, gestrichelte Linie, die den Mittelwert der
%   Spannung für t gegen Unendlich (= UP) anzeigt.

hold on

plot([t(1), t(length(t))], [Up, Up], 'LineStyle', "- -", 'Color', 'black')

hold off

%   Erstellen Sie eine zweite schwarze, gestrichelte Linie, die vom Mittelwert
%   der Spannung zum Maximum der Spannung geht.

hold on

plot([t_Umax, t_Umax], [Up, Umax], 'LineStyle', "- -", 'Color', 'black')

hold off

% 	Beschriften das Maximum der Spannung mit dem Befehl text und indem Sie
%   die Werte die in (t_Umax, Umax) gespeichert sind mit dem Befehl num2str verwenden:
%   Maximalwert: …

%Absätze sind noch störend.

text(t_Umax+0.025, Umax+0.5, ['Maximalwert: ', num2str(Umax), 'V bei ', num2str(t_Umax), 'sec'])

% f)Zeichnen Sie die obere Umhüllende Kurve in die Figur. 
% 	Die Linie soll rot gestrichelt sein und eine Liniendicke von 1 aufweisen.

figure(1);

hold on

plot(t, uenv, 'Color',  'red', 'LineWidth', 1, 'LineStyle', '- -')

hold off

% g)Zeichnen Sie die untere Umhüllende Kurve in die Figur. 
% 	Die Linie soll blau gestrichelt sein und eine Liniendicke von 1 aufweisen.

hold on

uevn=abs(uenv-20);

plot(t, uevn, 'Color',  'blue', 'LineWidth', 1, 'LineStyle', '- -')

hold off

%-----------------------------------------------------------------------------
% Aufgabe 2: Numerische Wertsuche / Wertbestimmung
%-----------------------------------------------------------------------------

% a)Die Anstiegszeit des Signals soll nun bestimmt werden.
%   Diese ist definiert, wie lange das Signal braucht, um von 10% bis
%   auf 90% des Endwertes anzusteigen.
%   Der Endwert (100%) ist der Signalwert für t gegen Unendlich (in diesem Fall UP).

t_U10=0;
t_U90=0;

for round=1:length(t)
    if ut(round) < (Up/10)
        t_U10=t(round);
    elseif ut(round) > (Up*9/10)
        t_U90=t(round);
        break %Abbruch, wenn erstes Mal erreicht.
    end
    %round %Test
end

% 	Bestimmen Sie den Zeitpunkt t_U10, bei dem die Spannung ut 10% des
%   Signalendwertes erreicht.


% 	Bestimmen Sie den Zeitpunkt t_U90, bei dem die Spannung ut das erste mal
%   90% des Signalendwertes erreicht.


% 	Berechnen Sie daraus die Anstiegszeit trise

trise=t_U90-t_U10

% 	Zeichnen Sie die Schnittpunkte von (t_U10,U10), (t_U90,U90) mittels eines
%   Kreuzes in die Figur. Die Liniendicke soll 2 betragen und die Markersize 8.

hold on

plot(t_U10, Up/10, 'Color',  'blue', 'Marker', "+", 'MarkerSize', 8, 'LineWidth', 2)
plot(t_U90, Up*9/10, 'Color',  'blue', 'Marker', "+", 'MarkerSize', 8, 'LineWidth', 2)

hold off

% 	Zeichnen Sie grüne und gestrichelte Linien ein, die zu diesen zwei Punkten hinführen.

hold on

plot([t_U10, t_U10], [0, Up/10], 'Color',  'green', 'LineWidth', 1, 'LineStyle', '- -')
plot([t_U90, t_U90], [0, Up*9/10], 'Color',  'green', 'LineWidth', 1, 'LineStyle', '- -')
plot([t(1), t_U10], [Up/10, Up/10], 'Color',  'green', 'LineWidth', 1, 'LineStyle', '- -')
plot([t(1), t_U90], [Up*9/10, Up*9/10], 'Color',  'green', 'LineWidth', 1, 'LineStyle', '- -')

hold off

% b)Bestimmen Sie vom Vektor ut das lokale Minimum der Kurve.

Umin=Umax;
Umin_index=IND_Umax;

for round=IND_Umax:length(t)
   if ut(round) < Umin
      Umin=ut(round);
      Umin_index=round;
   end
end

% 	Zeichnen Sie dieses lokale Minimum in die Grafik und beschriften
%   Sie dieses mit „lokales Minimum“.

hold on

plot(t(Umin_index), ut(Umin_index),'Marker', "+", 'MarkerSize', 8, 'LineWidth', 2)

hold off

%-----------------------------------------------------------------------------
% Aufgabe 3: Tanzende Flammen
%-----------------------------------------------------------------------------

% a)Halbieren Sie den Vektor ut, damit dieser nur noch die erste Hälfte des
%   ursprünglichen Vektors ausweist.
%   Grösse u2t: [1 length(ut)/2]

u2t=ut(1:length(ut)/2);
 
% b)Erzeugen Sie einen Vektor u2tflip , indem Sie den Vektor u2t um 180° drehen
%   (spiegeln an der vertikalen Achse)
%   Grösse u2tflip: [1 length(u2t)]

u2tflip=-u2t;

% c) Erzeugen Sie einen Vektor z , indem Sie die zwei Vektoren
%   u2tflip und u2t zusammenfügen (die Elemente aneinander reihen).
%   Grösse z: [1 length(ut)]

z=[u2tflip, u2t];

% d)Erzeugen eine Matrize z_3D indem Sie den Vektor z mit dem
%   Vektor z multiplizieren.
%   Grösse z_3D: [length(ut) length(ut)]

z_3D=z'*z;

% e)Zeichnen Sie die entstandene Fläche 1 mit dem Befehl surf(x,y,z),
%   wobei x und y jeweils der Vektor t ist. Z ist die Matrize z_3D.
%   Hinweis: Falls die Figur nicht wie erwünscht erscheint, müssen Sie z_3D transponieren.
%   Halten Sie diese Fläche 1 mit hold on

figure(2);

hold on %Fehlerhaft

Matrix = surf(t, t, z_3D)

hold off

% f)Zeichnen Sie eine zweite Fläche, den Boden auch mit dem Befehl surf(x,y,z).
%   x und y sind Vekotren der Länge length(t). Z ist eine quadratische Matrize aus lauter Nullen.
%   Grösse z: [length(t) length(t)]

hold on

z_0=zeros(length(t), length(t));

%surf()

hold off
    
% g)Setzten Sie von der Fläche 1 das Property 'EdgeAlpha' auf 0.
% 	Setzen Sie colormap auf hot
% 	Schalten Sie die Achsen aus

hold on

Matrix.set('EdgeAlpha', 0)

colormap hot

axis off

hold off
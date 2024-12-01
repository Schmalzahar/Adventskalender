% sphere
R = 1.333; % refractive index of glass
% sphere = @(x,y) x.^2+y.^2 == 1;

% first beam
fb_ang_0 = @(d) asin(d/1);
fb_x = @(d) -sqrt(1-d^2);
fb_ang_1 = @(d) snell(fb_ang_0(d),R);
h1 = @(d) pi/2 - fb_ang_0(d); % helper angle 1
h2 = @(d) h1(d) + fb_ang_1(d); % helper angle 2
syms t positive
beam_1_helpeq_t = @(d)solve((fb_x(d) + t*sin(h2(d)))^2 + (d-t*cos(h2(d)))^2 == 1,t);
beam_1_x = @(d) fb_x(d) + beam_1_helpeq_t(d) * sin(h2(d));
beam_1_y = @(d) d - beam_1_helpeq_t(d) * cos(h2(d));

h3 = @(d) atan(beam_1_y(d)/beam_1_x(d));
h4 = @(d) h3(d) + fb_ang_1(d);

beam_2_helpeq_t = @(d)solve((beam_1_x(d) -t*cos(h4(d)))^2 + (beam_1_y(d)-t*sin(h4(d)))^2 == 1,t);
beam_2_x = @(d) beam_1_x(d) - beam_2_helpeq_t(d) * cos(h4(d));
beam_2_y = @(d) beam_1_y(d) - beam_2_helpeq_t(d) * sin(h4(d));

fb_ang_3 = @(d) snell(fb_ang_1(d),R);

h5 = @(d) acos(eval(-beam_2_y(d)));
h6 = @(d) h5(d) + fb_ang_3(d);

final_angle = @(d) pi/2 - h6(d);


d_ar = 0:0.005:1;
res_ar = zeros(size(d_ar));
for i=1:size(d_ar,2)
    res_ar(i) = final_angle(d_ar(i));
end

plot(d_ar,res_ar*180/pi)
function ang_out = snell(ang_in, R)
    sin_angout =  sin(ang_in)/R;
    ang_out = asin(sin_angout);
end
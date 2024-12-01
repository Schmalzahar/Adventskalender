close all
% animation of: https://www.youtube.com/watch?v=24GfgNtnjXc&t=520s
% sphere
R = 1.333; % refractive index of glass

% first beam
fb_ang_0 = @(d) asin(d/1);
fb_x = @(d) -sqrt(1-d^2);

fb_ang_1 = @(d) snell(fb_ang_0(d),R);
h1 = @(d) pi/2 - fb_ang_0(d); % helper angle 1
h2 = @(d) h1(d) + fb_ang_1(d); % helper angle 2

% caching
beam_1_t_name = "beam_1_helpeq_t_"+num2str(R)+".mat";
if isfile(beam_1_t_name)
    load(beam_1_t_name)
    d_ar = 0:0.001:1;
else
    syms c positive
    beam_1_helpeq_t = @(d) solve((fb_x(d) + c*sin(h2(d)))^2 + (d-c*cos(h2(d)))^2 == 1,c);
    d_ar = 0:0.001:1;
    b_ar = zeros(size(d_ar));
    for i=1:size(d_ar,2)
        temp = beam_1_helpeq_t(d_ar(i));
        b_ar(i) = max(eval(temp(eval(temp)>0)));        
    end  
    save(beam_1_t_name,"b_ar")
end

% beam_1_helpeq_t = @(d) b_ar(d == d_ar);

beam_1_helpeq_t = @(d) interp1(d_ar,b_ar,d);
beam_1_x = @(d) fb_x(d) + beam_1_helpeq_t(d) * sin(h2(d));
beam_1_y = @(d) d - beam_1_helpeq_t(d) * cos(h2(d));

h3 = @(d) atan(beam_1_y(d)/beam_1_x(d));
h4 = @(d) h3(d) + fb_ang_1(d);


% caching
beam_2_t_name = "beam_2_helpeq_t_"+num2str(R)+".mat";
if isfile(beam_2_t_name)
    load(beam_2_t_name)
else
    syms c positive
    beam_2_helpeq_t = @(d)solve((beam_1_x(d) -c*cos(h4(d)))^2 + (beam_1_y(d)-c*sin(h4(d)))^2 == 1,c);
    b_ar2 = zeros(size(d_ar));
    for i=1:size(d_ar,2)
        temp = beam_2_helpeq_t(d_ar(i));
        b_ar2(i) = max(eval(temp(eval(temp)>0)));        
    end  
    save(beam_2_t_name,"b_ar2")
end
beam_2_helpeq_t = @(d) interp1(d_ar,b_ar2,d);

beam_2_x = @(d) beam_1_x(d) - beam_2_helpeq_t(d) * cos(h4(d));
beam_2_y = @(d) beam_1_y(d) - beam_2_helpeq_t(d) * sin(h4(d));

fb_ang_3 = @(d) snell(fb_ang_1(d),1/R); % this one is going outside again

h5 = @(d) asin((-beam_2_x(d)));
h6 = @(d) h5(d) + fb_ang_3(d);

final_angle = @(d) pi/2 - h6(d);

res_ar = zeros(size(d_ar));
for i=1:size(d_ar,2)
    res_ar(i) = final_angle(d_ar(i));
end

tmin = 0;
tmax = 1;
fr = 1000;
syms t x
hold on
% circle
fplot(cos(x),sin(x))
% center
fplot(0*x,0*x,"*")
% first beam
fanimator(@(t) plot([-3 fb_x(t)],[t t],'r'),'AnimationRange',[tmin tmax],'FrameRate',fr)
% reflection of first beam
fanimator(@(t) plot([fb_x(t) fb_x(t)-1*cos(2*fb_ang_0(t))],[t t+sin(2*fb_ang_0(t))],'r'),'AnimationRange',[tmin tmax],'FrameRate',fr)
% line from center to touch of first beam
fanimator(@(t) plot([0*x 2*fb_x(t)],[0*x 2*t],"LineStyle",':','Color',"k"),'AnimationRange',[tmin tmax],'FrameRate',fr)
% second beam
fanimator(@(t) plot([fb_x(t) beam_1_x(t)],[t beam_1_y(t)],'b'),'AnimationRange',[tmin tmax],'FrameRate',fr)
% reflection of second beam
fanimator(@(t) plot([beam_1_x(t) beam_2_x(t)],[beam_1_y(t) beam_2_y(t)],'b'),'AnimationRange',[tmin tmax],'FrameRate',fr)
% line fromc enter to touch of second beam
fanimator(@(t) plot([0*x 2*beam_1_x(t) ],[0*x 2*beam_1_y(t)],"LineStyle",':','Color',"k"),'AnimationRange',[tmin tmax],'FrameRate',fr)
% third beam
fanimator(@(t) plot([beam_2_x(t) beam_2_x(t)-1*sin(h6(t))],[beam_2_y(t) beam_2_y(t)-1*cos(h6(t))],'g'),'AnimationRange',[tmin tmax],'FrameRate',fr)
% line from center to touch of third beam
fanimator(@(t) plot([0*x 2*beam_2_x(t) ],[0*x 2*beam_2_y(t)],"LineStyle",':','Color',"k"),'AnimationRange',[tmin tmax],'FrameRate',fr)
% texts
fanimator(@(t) text(1.3, 1.5, "d = "+num2str(t)),'AnimationRange',[tmin tmax],'FrameRate',fr)
fanimator(@(t) text(1.3, 1.4, "a1 = "+num2str(fb_ang_1(t)*180/pi)),'AnimationRange',[tmin tmax],'FrameRate',fr)
fanimator(@(t) text(1.3, 1.3, "a2 = "+num2str(fb_ang_3(t)*180/pi)),'AnimationRange',[tmin tmax],'FrameRate',fr)
fanimator(@(t) text(1.3, 1.2, "fa = "+num2str(final_angle(t)*180/pi)),'AnimationRange',[tmin tmax],'FrameRate',fr)

axis equal
hold off
playAnimation("SpeedFactor",0.5)


figure()
plot(d_ar,res_ar*180/pi)
function ang_out = snell(ang_in, R)
    sin_angout =  sin(ang_in)/R;
    ang_out = asin(sin_angout);
end
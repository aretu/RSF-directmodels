import mlreportgen.ppt.*;

ppt = Presentation("auto_benchmark.pptx","style.potx");
open(ppt);

% layouts and templates are tricky.

slide1 = add(ppt,"Diapositiva titolo");
replace(slide1,"Titolo 1",'Benchmarking Rudnicki models');
replace(slide1,"Sottotitolo 2","Using matlab functions");
replace(slide1,"Piè di pagina","Stefano Aretusini");
 
%%
cd ./plots/

pngfiles = dir('*.png');

for file = pngfiles'

%     I = imread(file);
    plot1 = Picture(file.name);

    plot1.Width = "33.87cm";
    plot1.Height = "17.55cm";

    slide2=add(ppt,"Titolo e contenuto 2");

    replace(slide2,"Titolo 1",file.name)
    replace(slide2,"Segnaposto contenuto 2",plot1)
    
end

close(ppt);
%%
% slide2 = add(ppt,"Title and Content");
% para = Paragraph("First Content Slide");
% para.FontColor = "blue";
% replace(slide2,"Title",para);
%  
% replace(slide2,"Content",["First item","Second item","Third item"]);
%  
% close(ppt);

%%
cd ..
rptview(ppt)
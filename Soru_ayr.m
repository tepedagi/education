% .pdf dosyasını okur, sayfalarına ayırır, her sayfayı ve negatifini diske
% kayıt eder. Scan edilen ya da indirilen .pdf dosyaları belirli bir yerde
% tutulmalıdır. InputFolder adına atanmalıdır.
addpath 'C:\Users\mount\MATLAB\Projects\TrainNetworkProject1'
load sorumu1_ai 'trainedNetwork_1' 'trainInfoStruct_1'
prompt = {'Ders girin','Ünite Girin'};
dlgtitle = 'Girdi';
dims = [1 35];
definput = {'10.Sınıf Matematik','Üçgenler'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
Konu = [38;43;38;40;49];
SoruNo = logical([1;0;1;0;1]);
varNames = {'Ders','Konu','Soru Name','Soru Yolu'};

InputFolder= 'C:\Users\mount\OneDrive\Belgeler\PROJE2203EGTM\SCANFOLDER';
% Image Veri Tabanı tanımlama
imds=imageDatastore(InputFolder,"FileExtensions",'.pdf');
FNAMES=[];
FNAMES2=[];

for sayac2 = 1:length(imds.Files)

FPATH = imds.Files(sayac2); % Tüm yol

level = wildcardPattern + "\";
pat = asManyOfPattern(level);
filename = extractAfter(FPATH,pat); % Dosya adı 

% PDF'ten .png'ye dönüştürme
resimler=PDFtoIMG2(filename); 

% Resim ön işleme ve negatife alma
for z=1:length(resimler)

    % imshow(resimler(z))

    hedef = imread(resimler(z));
    %hedef=imrotate(hedef,0,"bilinear","loose");

    redChannel = hedef(:, :, 1);
    greenChannel = hedef(:, :, 2);
    blueChannel = hedef(:, :, 3);

    [boy,en]=size(redChannel);

    % imshow(redChannel)

    HedefGri=rgb2gray(hedef);

    level = graythresh(HedefGri);

    BW = imbinarize(HedefGri,level);

    % imshow(HedefGri) imshow(BW)

    BWTers=255-HedefGri;

    %imshow(BWTers)

    FNAME2= resimler(z) + '_g.png';
    FNAME3= resimler(z) + '_x';

    FNAMES=[FNAMES FNAME2];
    FNAMES2=[FNAMES2 FNAME3];

    imwrite(BWTers,FNAME2,"png"); % Negatifler
    imwrite(HedefGri,FNAME3,"png"); % Gri'ler
    
end

end

%% Yaklaşım 1 

sayfalar=length(FNAMES);

for sss=1:sayfalar
        HedefGri=imread(FNAMES2(sss));
        BWTers=imread(FNAMES(sss));
        ansFULL=sum(BWTers);
        %aa=imrotate(BWTers,1);
        %hatabul=sum(aa);
        %plot(hatabul)
        %[~,Dikey2]=max(hatabul);
        %figure
        %plot(ansFULL)
        [Index,DikeyKes]=max(ansFULL(500:1500));
        % DikeyKes-10 > Sol taraf için Sağ Alt köşe Y koordinatıdır.
        % DikeyKes+10 > Sağ taraf için Sol Üst Köşe Y Koordinatıdır.
        % Eğer DikeyKes küçük bir sayı ise (<1000) Orta Bölme YOKTUR
        % Sayfa İkiye bölünüyor
        [Rows,Cols]=size(BWTers);
        if DikeyKes>1000 
            SayfaSol=BWTers(:,1:DikeyKes-10);
            SayfaSag=BWTers(:,DikeyKes+10:Cols);
        else

            %stepRotate=1; % 1'er derece açı ile dön
            %sayac3=0; %Dönüş sayısını saymak için
            %donus=true;
            %while and(DikeyKes<1000,donus)
            %    sayac3=sayac3+1;
            %    donFULLR=imrotate(BWTers,stepRotate*(-1),'bilinear','crop');
            %    ansFULLR=sum(donFULLR);
            %    [~,DikeyKesR]=max(ansFULLR(500:1500));
            %            figure
            %            plot(ansFULLR)
            %    donFULLL=imrotate(BWTers,stepRotate*1,'bilinear','crop');
            %    ansFULLL=sum(donFULLL);
            %    [~,DikeyKesL]=max(ansFULLL);
                                %figure
                                %plot(ansFULLL)
            %    if and(DikeyKesR<DikeyKes,DikeyKesL<DikeyKes)
            %        donus=false;
            %        fprintf("Format bozuk ya da soru sayfası değil");
            %    end 
            %    if DikeyKesR>=DikeyKes
            %        while donus    
            %        donFULLR2=imrotate(donFULLR,stepRotate);
            %        ansFULLR2=sum(donFULLR2);
            %        [~,DikeyKesR2]=max(ansFULLR2);
                                %figure
                                %plot(ansFULLR2)
            %            if DikeyKesR>=DikeyKesR2 
            %            donus=false;
            %                if DikeyKesR>1000
            %               SayfaSag=donFULLR(:,DikeyKesR+10:Cols);
            %                end
            %            end
            %        donFULLR=donFULLR2;
            %        DikeyKesR=DikeyKesR2;
            %        end
            %    end
            %    if DikeyKesL>=DikeyKes
            %        while donus    
            %        donFULLL2=imrotate(donFULLL,stepRotate*(-10));
            %        ansFULLL2=sum(donFULLL2);
            %                figure
            %                plot(ansFULLL2)
            %        [~,DikeyKesL2]=max(ansFULLL2);
            %            if DikeyKesL>=DikeyKesL2 
            %            donus=false;
            %                if DikeyKesL>1000
            %               SayfaSol=donFULLL(:,DikeyKesL-10:Cols);
            %                end
            %            end
            %        donFULLL=donFULLL2;
            %        DikeyKesL=DikeyKesL2;
            %        end
            %    end
             %end
            DikeyKes=int16(Cols/2);
            SayfaSol=BWTers(:,1:DikeyKes-10);
            SayfaSag=BWTers(:,DikeyKes+10:Cols);
        end

             
        anssol=sum(SayfaSol,2);
        anssag=sum(SayfaSag,2);
        % imshow(SayfaSol)
        % figure
        % imshow(SayfaSag)

        % Böylece Soruların başlangıç ve bitişlerini tespit edebileceğiz
            %figure
        %plot(anssol)
        %figure
        %plot(anssag)
        % Hesaplamaya devam edelim SADECE 1 SAYFA İÇİNDİR
        % Yeni bir değişken ancak sağdan 50 soldan 50 ort alıyor
        boysol=length(anssol);
        boysag=length(anssag);
        param1=150; % Ortalama alma aralığı
        param2=150; % Sayfa başı
        param3=250; % Sayfa sonu
        %treshold=250; % Bu rakamdan küçük alanlar atlanacak Eşik Değer değişebilir

        for i=1:boysol
            degis=0;
            sayfasay=0;
            if and(((i-param2)>0),(i+param3)<boysol) 
                for j=i-param1:i+param1
                    sayfasay=sayfasay+1;
                    degis=degis+anssol(j);
                end
                anssoly(i)=degis/sayfasay;
            else
                anssoly(i)=0;
            end
        end
        figure;
        plot(anssoly)
        tresholdl=max(anssoly)*0.05; % Bu rakamdan küçük alanlar atlanacak Eşik Değer değişebili

        for i=1:boysag
            degis=0;
            sayfasay=0;
            if and(((i-param2)>0),(i+param3)<boysag) 
                for j=i-param1:i+param1
                    sayfasay=sayfasay+1;
                    degis=degis+anssag(j);
                end
                anssagy(i)=degis/sayfasay;
            else
                anssagy(i)=0;
            end
        end
        figure;
        plot(anssagy)

        tresholdr=max(anssagy)*0.05; % Bu rakamdan küçük alanlar atlanacak Eşik Değer değişebili        

        indsol=anssoly>tresholdl; % Mantıksal filtreleme yap
        indsag=anssagy>tresholdr; % Sağ ve sol ayrı ayrı
        
        yerel=0;
        say=0;
        for i=1:(numel(indsol)-1)
            if indsol(i)~=indsol(i+1)
                say=say+1;
                yerel(say)=i;
            end
        end
        fprintf('Sol taraf soru sayısı :  %d\n',((say)/2));
        yerel
        
    yerel2=0;
    say2=0;
         for i=1:(numel(indsag)-1)
            if indsag(i)~=indsag(i+1)
                say2=say2+1;
                yerel2(say2)=i;
            end
        end
        fprintf('Sag taraf soru sayısı :  %d\n',((say2)/2));
        yerel2

% Sayfanın Soru Koordinatlarını toplayalım 
% Format SOL UST X1 , Y1 , X2 , Y2 olacak
            ls=0;
        for i=1:2:numel(yerel)
            ls=ls+1;
            koordltx(ls)=yerel(i);
            koordlty(ls)=1;
            koordlbx(ls)=yerel(i+1);
            koordlby(ls)=DikeyKes-10;
        end
            rs=0;
        for i=1:2:numel(yerel2)
            rs=rs+1;
            koordrtx(rs)=yerel2(i);
            koordrty(rs)=DikeyKes+10;
            koordrbx(rs)=yerel2(i+1);
            koordrby(rs)=Rows;
        end


% Şimdi ilgili koordinatlara gidip orijinal dökümandan ROI
% olarak belirlediğimiz alanı çekelim. 
% Sol taraf
        for i=1:numel(koordltx)
            if (koordlbx(i)-koordltx(i))>180
            I=imcrop(HedefGri,[koordlty(i),koordltx(i),koordlby(i)-koordlty(i),koordlbx(i)-koordltx(i)]);

            CurrentFolder=pwd;
            d=datetime("now","Format","dd-MMM-uuuu-HH-mm-ss-SS");
            %pause(1);
            name='MLS'+ string(d) +'.png'; % Dosya adı oluştur
            tamyol=string(CurrentFolder+name);
            
            rgb_image = cat(3, I, I, I);

            Regs=imresize(rgb_image,[227 227]);
            [YPred,probs]=classify(trainedNetwork_1,Regs);


            %if YPred=="Soru"
            T = table(string(answer{1}),string(answer{2}),d,tamyol,'VariableNames',varNames);
            imwrite(rgb_image,name);
            writetable(T,'Soru_DB.csv','WriteMode','Append',...
            'WriteVariableNames',false,'WriteRowNames',true)  
            
            figure
            imshow(rgb_image);
            label = YPred;
            title (string(label) + ', ' + num2str(100*max(probs),3 + '%'));
            
            %end
            
            %figure
            %imshow(rgb_image);
            %label = YPred;
            %title (string(label) + ', ' + num2str(100*max(probs),3 + '%'));
            end
        end
        
        
        for i=1:numel(koordrtx)
            % width=koordrbx(i)-koordrtx(i);
            if (koordrbx(i)-koordrtx(i))>180
            I=imcrop(HedefGri,[koordrty(i),koordrtx(i),koordrby(i)-koordrty(i),koordrbx(i)-koordrtx(i)]);
            
            CurrentFolder=pwd;
            d=datetime("now","Format","dd-MMM-uuuu-HH-mm-ss-SS");
            %pause(1);
            name='MRS'+ string(d) +'.png'; % Dosya adı oluştur
            rgb_image = cat(3, I, I, I);
            
            Regs=imresize(rgb_image,[227 227]);
            [YPred,probs]=classify(trainedNetwork_1,Regs);
            
            tamyol=string(CurrentFolder+name); 
            
            %if YPred=="Soru"
            T = table(string(answer{1}),string(answer{2}),d,tamyol,'VariableNames',varNames);
            imwrite(rgb_image,name);
            writetable(T,'Soru_DB.csv','WriteMode','Append',...
            'WriteVariableNames',false,'WriteRowNames',true)  
            figure
            imshow(rgb_image);
            label = YPred;
            title (string(label) + ', ' + num2str(100*max(probs),3 + '%'));
            
            
            
            %end

            %figure
            %imshow(rgb_image);
            %label = YPred;
            %title (string(label) + ', ' + num2str(100*max(probs),3 + '%'));

            end
        end
end    
        %imshow(HedefGri)
        % save sorumu1_ai 'trainedNetwork_1' 'trainInfoStruct_1'




        %% 

prompt = {'Ders girin','Konu Girin'};
dlgtitle = 'Girdi';
dims = [1 35];
definput = {'Matematik','Geometri'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
Konu = [38;43;38;40;49];
SoruNo = logical([1;0;1;0;1]);
varNames = {'Ders','Konu','Soru Name','Soru Yolu'};


T = table(answer{1},answer{2},d,name,'VariableNames',varNames);





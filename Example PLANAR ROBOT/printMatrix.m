function  []=printMatrix(M,nameM,ext,dir,dot,anadir)

disp('Deleting small terms...')

if length(dir)>0
    fileName = [dir '\' nameM 'Matrix.' ext];
else
    fileName = [nameM 'Matrix.' ext];
end
fileID = fopen(fileName,'w');

fprintf(fileID,'%s\n',anadir);
fprintf(fileID,'%s=[ ',nameM);
for y=1:size(M,1)
    terminos=0;
for x=1:size(M,2)
    aux=char(vpa(expand(M(y,x)),2));
    
    cont=1; indices=1;
    for k=2:length(aux)-1
        if aux(k)=='+' || aux(k)=='-'
            if aux(k-1)==' ' && aux(k+1)==' '
                cont=cont+1;
                indices=[indices k];
            end
        end
    end
    indices=[indices length(aux)];

    for k=1:length(indices)-1
        for j=indices(k):indices(k+1) %ubicamos exponente dentro de la ecuacion
            if aux(j)=='e' && ( aux(j+1)=='-'  ) %buscamos exponente negativo
                jjI=j+2; jjF=jjI;
                while aux(jjF)>='0' && aux(jjF)<='9' %lee exponente
                    jjF=jjF+1;
                end
                jjF=jjF-1;
                exponente=str2num(aux(jjI:jjF));
                if exponente>=3
                    terminos=terminos+1;
                   rev=j;
                   while aux(rev)~=' ' %poner el coeficiente en cero
                       if aux(rev)>='1' && aux(rev)<='9'
                           aux(rev)='0';
                       end
                       rev=rev-1;
                       if rev==0
                        break;
                       end
                   end
                end
            end
        end
    end
        
    aux=expand(simplify(evalin(symengine,aux)));
    
    if dot
        aux = strrep(char(aux),'*','.*')
    end
    
    fprintf(fileID,'%s, ',aux);
    
    disp([ num2str(terminos) ' terms deleted'])
    
end
    fprintf(fileID,';\n');
end
fprintf(fileID,'];');
fclose(fileID);

nameM
end
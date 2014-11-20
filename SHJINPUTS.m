function [inpatterns,teachVals]=SHJINPUTS(type)

teachVals= [ 1		-1
			 1		-1
			 1		-1
			 1		-1
			-1		 1
			-1		 1
			-1		 1
			-1		 1];		

if  type==1
	inpatterns= [1	 1	 1
				 1	 1	-1
				 1	-1	 1
				 1	-1	-1
				-1	-1	 1
				-1	-1	-1
				-1	 1	 1
				-1	 1	-1];		
 end

if  type==2
	inpatterns= [1	 1	 1
				 1	 1	-1
				-1	-1	 1
				-1	-1	-1
				-1	 1	 1
				-1	 1	-1
				 1	-1	 1
				 1	-1	-1];		
end

if  type==3
	inpatterns=	[1	 1	 1
				 1	 1	-1
				 1	-1	 1
				-1	 1	-1
				 1	-1	-1
				-1	 1	 1
				-1	-1	 1
				-1	-1	-1];		
end

if  type==4
	inpatterns= [1	 1	 1
				 1	 1	-1
				 1	-1	 1
				-1	 1	 1
				 1	-1	-1
				-1	 1	-1
				-1	-1	 1
				-1	-1	-1];		
end

if  type==5
	inpatterns= [1	 1	 1
				 1	 1	-1
				 1	-1	 1
				-1	-1	-1
				 1	-1	-1
				-1	 1	 1
				-1	 1	-1
				-1	-1	 1];		
end

if  type==6
	inpatterns= [1	 1	 1
				 1	-1	-1
				-1	 1	-1
				-1	-1	 1
				 1	 1	-1
				 1	-1	 1
				-1	 1	 1
				-1	-1	-1];		
end
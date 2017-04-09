#include "mex.h"
#include <stdlib.h>
#include <math.h>
//函数格式[judge,r,gailv]=cknear(k,sampleset,samplesign,testset)
//[judge,r]=cknear(k,sampleset,samplesign,testset)
//judge=cknear(k,sampleset,samplesign,testset)
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    double *sampleset,*testset,*samplesign;
    double *K,*Ki,*gailv,*res,*num,*judge;   //judge作为存放检测样本的标志 .num存放最近点属于各类的点的个数
    double g,a;
	double *temp1,*temp2,*temp3;
    int M,N,G,len,k;       //g为类数
    int i,j,r,b;
    if(nlhs>3||nrhs!=4)
    {
        mexErrMsgTxt("the number of input must be 4 and the number of output must be 3 or less than 3");
    }
    M=mxGetM(prhs[1]);  //取得样本矩阵的大小
    N=mxGetN(prhs[1]);
    len=mxGetM(prhs[3]);//len赋值testset的数目
    sampleset=mxGetPr(prhs[1]);   //对输入数据进行取值
    samplesign=mxGetPr(prhs[2]);
    testset=mxGetPr(prhs[3]);
    g=0;
    for(i=0;i<M;i++)           //g取样本标志的最大值
    {
        if(samplesign[i]>g)
            g=samplesign[i];
    }
    G=(int)g;
    K=mxGetPr(prhs[0]);
    k=(int)K[0];                 //读取第一个输入数据，赋值k
    Ki=(double *)mxMalloc(len*sizeof(double)); //重新定义Ki，作为存放最大半径
    judge=(double *)mxMalloc(len*sizeof(double)); //开辟判断矩阵空间
    res=(double *)mxMalloc(M*sizeof(double)); //res存放欧式距离
    gailv=(double *)mxMalloc(len*G*sizeof(double)); //gailv=mxCreateDoubleMatrix(len,G,mxREAL);//定义概率矩阵
    num=(double *)mxMalloc(G*sizeof(double)); //num[G]
    for(i=0;i<len;i++)                   //对每个检测数据进行操作
    { 
        for(j=0;j<M;j++)
        {
           res[j]=0;
           for(r=0;r<N;r++)
              res[j]=res[j]+(sampleset[j+r*M]-testset[i+r*len])*(sampleset[j+r*M]-testset[i+r*len]);
        }
        for(j=0;j<G;j++)
           num[j]=0;
        //寻找k个最近点代码，赋点的个数num[j]
        for(j=0;j<k;j++)
        {
            a=res[0];
            b=0;
			while(a<=1.e-8)
			{				
				b=b++;
				a=res[b];				
			}
            for(r=0;r<M;r++)
            {
              if((a>res[r]) && (res[r]>1.e-8))
              {
                  a=res[r];
                  b=r;
              }
            }
            if(j==k-1)        //第k个最小数作为半径的平方赋值Ki
            {
                Ki[i]=sqrt(res[b]);
            } 
            res[b]=-1;    //置数以及统计
            num[(int)samplesign[b]-1]=num[(int)samplesign[b]-1]+1;       
        }
        //计算每类概率，赋值概率矩阵
        g=num[0];
        r=0;
        for(j=0;j<G;j++)
        {        
            gailv[i+j*len]=num[j]/k;
            if(g<num[j])       //寻找最多的num，并r=j，，j+1为标识
            {
                g=num[j];
                r=j;
            }
        }
        judge[i]=r+1;    //赋值判断矩阵
    }

    if(nlhs==3)
    {
      plhs[0]=mxCreateDoubleMatrix(len,1,mxREAL);//开辟空间输出矩阵，存放判断标志，m*1维
      plhs[1]=mxCreateDoubleMatrix(len,1,mxREAL);//存放第k个最近点的距离
      plhs[2]=mxCreateDoubleMatrix(len,G,mxREAL);//存放样本属于该类的概率
	  temp1 = mxGetPr(plhs[0]);
	  temp2 = mxGetPr(plhs[1]);
	  temp3= mxGetPr(plhs[2]);
	  for(i=0;i<len;i++)
	  { 
		   temp1[i] = judge[i];
		   temp2[i]=  Ki[i];
		  for(j=0;j<G;j++)
			  temp3[i+j*len]=gailv[i+j*len];		  
	  }
      //mxSetPr(plhs[0],judge);           //输出赋值
     // mxSetPr(plhs[1],Ki);
      //mxSetPr(plhs[2],gailv);
    }
    else if(nlhs==2)
    {
       plhs[0]=mxCreateDoubleMatrix(len,1,mxREAL);//开辟空间输出矩阵，存放判断标志，m*1维
       plhs[1]=mxCreateDoubleMatrix(len,1,mxREAL);//存放第k个最近点的距离
	   temp1 = mxGetPr(plhs[0]);
	  temp2 = mxGetPr(plhs[1]);	
	  for(i=0;i<len;i++)
	  { 
		   temp1[i] = judge[i];
		   temp2[i]=  Ki[i];		  
		  
	  }
    //   mxSetPr(plhs[0],judge);           //输出赋值
      // mxSetPr(plhs[1],Ki);
    }
    else
    {
        plhs[0]=mxCreateDoubleMatrix(len,1,mxREAL);//开辟空间输出矩阵，存放判断标志，m*1维
		temp1 = mxGetPr(plhs[0]);
	  for(i=0;i<len;i++)
	  { 
		   temp1[i] = judge[i];		   
	  }
        //mxSetPr(plhs[0],judge); 
    }
    // k=(int)K[0];                 //读取第一个输入数据，赋值k
    //Ki=(double *)mxMalloc(len * sizeof(double));//重新定义Ki，作为存放最大半径
    //judge=(double *)mxMalloc(len * sizeof(double));//开辟判断矩阵空间
    //res=(double *)mxMalloc(M * sizeof(double));//res存放欧式距离
    //gailv=(double *)mxMalloc(len*G * sizeof(double));//gailv=mxCreateDoubleMatrix(len,G,mxREAL);//定义概率矩阵
    //num=(double *)mxMalloc(G * sizeof(double)); //num[G]
   mxFree(Ki);
   mxFree(judge);
   mxFree(res);
   mxFree(gailv);
   mxFree(num);
	return;
}
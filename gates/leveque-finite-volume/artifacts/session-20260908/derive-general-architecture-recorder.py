from pathlib import Path
S=Path(__file__).resolve().parent
text=(S/'record-interpreted-architecture-verification.py').read_text()
for a,b in [('interpreted-architecture','general-architecture'),('checkpoint-4a29be754','checkpoint-eed529aaf'),('4a29be754145fb1099e35feb679df6d4e524acc8','eed529aaf650561fb72318c5264bb074c1652ce3'),('5925','5932'),('60347','60359'),('272296','272318'),('393185','393230')]:
 text=text.replace(a,b)
p=S/'record-general-architecture-verification.py';assert not p.exists();p.write_text(text,encoding='utf-8',newline='\n')

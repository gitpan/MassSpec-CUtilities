#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include <string.h>
#ifndef WIN
#ifdef MAC_MEMORY
#include <malloc/malloc.h>
#else
#include <malloc.h>
#endif
#endif /* WIN */

typedef struct node {
	int value;
	struct node* left;
	struct node* right;
} Node, *NodePtr;


double lookup[128] = {
	0, /* 0  */
	0, /* 1  */
	0, /* 2  */
	0, /* 3  */
	0, /* 4  */
	0, /* 5  */
	0, /* 6  */
	0, /* 7  */
	0, /* 8  */
	0, /* 9  */
	0, /* 10  */
	0, /* 11  */
	0, /* 12  */
	0, /* 13  */
	0, /* 14  */
	0, /* 15  */
	0, /* 16  */
	0, /* 17  */
	0, /* 18  */
	0, /* 19  */
	0, /* 20  */
	0, /* 21  */
	0, /* 22  */
	0, /* 23  */
	0, /* 24  */
	0, /* 25  */
	0, /* 26  */
	0, /* 27  */
	0, /* 28  */
	0, /* 29  */
	0, /* 30  */
	0, /* 31  */
	0, /* 32  */
	0, /* 33  */
	0, /* 34  */
	0, /* 35  */
	0, /* 36  */
	0, /* 37  */
	0, /* 38  */
	0, /* 39  */
	0, /* 40  */
	0, /* 41  */
	0, /* 42  */
	0, /* 43  */
	0, /* 44  */
	0, /* 45  */
	0, /* 46  */
	0, /* 47  */
	0, /* 48  */
	0, /* 49  */
	0, /* 50  */
	0, /* 51  */
	0, /* 52  */
	0, /* 53  */
	0, /* 54  */
	0, /* 55  */
	0, /* 56  */
	0, /* 57  */
	0, /* 58  */
	0, /* 59  */
	0, /* 60  */
	0, /* 61  */
	0, /* 62  */
	0, /* 63  */
	0, /* 64  */
	71.0371137878, /* 65  A  */
	0, /* 66  */
	103.0091844778, /* 67  C  */
	115.026943032, /* 68  D  */
	129.0425930962, /* 69  E  */
	147.0684139162, /* 70  F  */
	57.0214637236, /* 71  G  */
	137.0589118624, /* 72  H  */
	0, /* 73  */
	0, /* 74  */
	128.0949630177, /* 75  K  */
	0, /* 76  */
	131.0404846062, /* 77  M  */
	114.0429274472, /* 78  N  */
	0, /* 79  */
	97.052763852, /* 80  P  */
	128.0585775114, /* 81  Q  */
	156.1011110281, /* 82  R  */
	87.0320284099, /* 83  S  */
	101.0476784741, /* 84  T  */
	0, /* 85  */
	99.0684139162, /* 86  V  */
	186.0793129535, /* 87  W  */
	113.0840639804, /* 88  X  */
	163.0633285383, /* 89  Y  */
	0, /* 90  */
	0, /* 91  */
	0, /* 92  */
	0, /* 93  */
	0, /* 94  */
	0, /* 95  */
	0, /* 96  */
	0, /* 97  */
	0, /* 98  */
	0, /* 99  */
	0, /* 100  */
	0, /* 101  */
	0, /* 102  */
	0, /* 103  */
	0, /* 104  */
	0, /* 105  */
	0, /* 106  */
	0, /* 107  */
	0, /* 108  */
	0, /* 109  */
	0, /* 110  */
	0, /* 111  */
	0, /* 112  */
	0, /* 113  */
	0, /* 114  */
	0, /* 115  */
	0, /* 116  */
	0, /* 117  */
	0, /* 118  */
	0, /* 119  */
	0, /* 120  */
	0, /* 121  */
	0, /* 122  */
	0, /* 123  */
	0, /* 124  */
	0, /* 125  */
	0, /* 126  */
	0 /* 127  */
};

int primeLookup[128] = {
	0, /* 0  */
	0, /* 1  */
	0, /* 2  */
	0, /* 3  */
	0, /* 4  */
	0, /* 5  */
	0, /* 6  */
	0, /* 7  */
	0, /* 8  */
	0, /* 9  */
	0, /* 10  */
	0, /* 11  */
	0, /* 12  */
	0, /* 13  */
	0, /* 14  */
	0, /* 15  */
	0, /* 16  */
	0, /* 17  */
	0, /* 18  */
	0, /* 19  */
	0, /* 20  */
	0, /* 21  */
	0, /* 22  */
	0, /* 23  */
	0, /* 24  */
	0, /* 25  */
	0, /* 26  */
	0, /* 27  */
	0, /* 28  */
	0, /* 29  */
	0, /* 30  */
	0, /* 31  */
	0, /* 32  */
	0, /* 33  */
	0, /* 34  */
	0, /* 35  */
	0, /* 36  */
	0, /* 37  */
	0, /* 38  */
	0, /* 39  */
	0, /* 40  */
	0, /* 41  */
	0, /* 42  */
	0, /* 43  */
	0, /* 44  */
	0, /* 45  */
	0, /* 46  */
	0, /* 47  */
	0, /* 48  */
	0, /* 49  */
	0, /* 50  */
	0, /* 51  */
	0, /* 52  */
	0, /* 53  */
	0, /* 54  */
	0, /* 55  */
	0, /* 56  */
	0, /* 57  */
	0, /* 58  */
	0, /* 59  */
	0, /* 60  */
	0, /* 61  */
	0, /* 62  */
	0, /* 63  */
	0, /* 64  */
	3, /* 65  A  */
	0, /* 66  */
	17, /* 67  C  */
	29, /* 68  D  */
	41, /* 69  E  */
	53, /* 70  F  */
	2, /* 71  G  */
	47, /* 72  H  */
	0, /* 73  */
	0, /* 74  */
	37, /* 75  K  */
	0, /* 76  */
	43, /* 77  M  */
	23, /* 78  N  */
	0, /* 79  */
	7, /* 80  P  */
	31, /* 81  Q  */
	59, /* 82  R  */
	5, /* 83  S  */
	13, /* 84  T  */
	0, /* 85  */
	11, /* 86  V  */
	67, /* 87  W  */
	19, /* 88  X  */
	61, /* 89  Y  */
	0, /* 90  */
	0, /* 91  */
	0, /* 92  */
	0, /* 93  */
	0, /* 94  */
	0, /* 95  */
	0, /* 96  */
	0, /* 97  */
	0, /* 98  */
	0, /* 99  */
	0, /* 100  */
	0, /* 101  */
	0, /* 102  */
	0, /* 103  */
	0, /* 104  */
	0, /* 105  */
	0, /* 106  */
	0, /* 107  */
	0, /* 108  */
	0, /* 109  */
	0, /* 110  */
	0, /* 111  */
	0, /* 112  */
	0, /* 113  */
	0, /* 114  */
	0, /* 115  */
	0, /* 116  */
	0, /* 117  */
	0, /* 118  */
	0, /* 119  */
	0, /* 120  */
	0, /* 121  */
	0, /* 122  */
	0, /* 123  */
	0, /* 124  */
	0, /* 125  */
	0, /* 126  */
	0 /* 127  */
};

#ifdef WIN
typedef unsigned long Uverylong;
#else
typedef unsigned long long Uverylong;
#endif /* WIN */

#define UVLONG_MAX_8    18446744073709551615UL
#define UVLONG_MAX_4    4294967295UL

#define UVLONG_MAX (sizeof(Uverylong) >= 8 ? UVLONG_MAX_8 : UVLONG_MAX_4)
#define DANGER_ZONE (UVLONG_MAX/67)


static
Uverylong static_computePrimeProduct(char *peptide)
{
	Uverylong retval = 1;
	Uverylong temp;
#ifdef OVERFLOW_DEBUG
char *origpeptide = peptide;
#endif

	while (*peptide) {
		if (retval < DANGER_ZONE) {
			retval *= primeLookup[*peptide++];
		} else {
#ifdef OVERFLOW_DEBUG
printf("In danger zone %s, residual :%s:\n", origpeptide, peptide);
#endif
			temp = primeLookup[*peptide++];
			if (retval >= (UVLONG_MAX/temp)) {
#ifdef OVERFLOW_DEBUG
printf("Hit overflow %s\n", origpeptide);
#endif
				return 0;
			}
			retval *= temp;
		}
	}

	return retval;
}

/* compute many prime multiples, but give up early if any of them fail, and return and non-positive value */
static
int
static_computeManyPrimeProducts(char *peptides[], Uverylong retvals[], int count)
{
	int i;
	Uverylong val;

	for (i = 0; i < count; i++) {
		val = static_computePrimeProduct(peptides[i]);
		if (val == 0) {
			return (-i);
		}
		retvals[i] = val;
	}

	return count;
}

static NodePtr newNode(int data){

	NodePtr node = (NodePtr) malloc(sizeof(Node));
	node->value = data;
	node->left = NULL;
	node->right = NULL;

	return(node);
}

static NodePtr root = NULL;
static char *aa_syms = "ACDEFGHKMNPQRSTVWXY";


MODULE = MassSpec::CUtilities		PACKAGE = MassSpec::CUtilities		
double
computePeptideMass(peptide)
	char *peptide
	CODE:
		RETVAL= 0.0;
	
		do {
			RETVAL += lookup[*peptide++];
		} while (*peptide);
	OUTPUT:
		RETVAL

int
initDecoderTree(Huffman_code,values)
	AV *Huffman_code
	AV *values
	CODE:
#ifdef WIN
{
#endif
		int i;
		char *p;
		int count;
		SV **hc;
		SV **hv;
		STRLEN len;
		NodePtr cptr;

		RETVAL = 0;

		root = newNode(-2);
		cptr = root;

		count = av_len(Huffman_code);

		for (i = 0; i <= count; i++) {
			hc = av_fetch(Huffman_code,i,0);
			p = SvPV(*hc,len);
			hv = av_fetch(values,i,0);
#ifdef CUTILITIES_DEBUG
printf("Huffman code %s, value %ld\n", p, (long) SvIV(*hv));
#endif
			for (; *p; p++) {
				if (*p == '0') {
					if (!cptr->left) cptr->left = newNode(-2);
					cptr = cptr->left;
				} else {
					if (!cptr->right) cptr->right = newNode(-2);
					cptr = cptr->right;
				}
			}
			cptr->value = SvIV(*hv);
			if (cptr->value == -1) RETVAL = 1; /* must see at least one -1 stop code */
			cptr = root;
		}
#ifdef WIN
}
#endif
	OUTPUT:
		RETVAL

char *
fast_decode(encoded,len)
	unsigned char *encoded
	int len
	CODE:
		unsigned char *byteptr = encoded;
		unsigned char *maxptr = encoded + len;
		int done, i;
		unsigned char thebyte;
		
		int alpha_index = 0;
		int k = 0;
		struct node* curptr = root;

		char answer[50];
		
		for (done = 0; byteptr < maxptr && !done; byteptr++) {
			 thebyte = *byteptr;
#ifdef CUTILITIES_DEBUG
printf("Thebyte: %x\n",thebyte);
#endif
			 for (i = 0; i < 8; i++, thebyte >>= 1) {
				   if (thebyte & 1) {
#ifdef CUTILITIES_DEBUG
printf("Right\n");
#endif
					     if (! curptr->right) {
							RETVAL = 0;
#ifdef CUTILITIES_DEBUG
printf("Right bomb:");
for (done = 0; done < len; done++) {
printf("%02x",encoded[done]);
}
printf(", %d chars decoded:",k);
for (done = 0; done < k; done++) {
printf("%c",answer[done]);
}
printf("\n");
#endif

							done = 1;
							break;
						}
					     curptr = curptr->right;
				   } else {
#ifdef CUTILITIES_DEBUG
printf("Left\n");
#endif
					     if (! curptr->left) {
							RETVAL = 0;
#ifdef CUTILITIES_DEBUG
printf("Left bomb:");
for (done = 0; done < len; done++) {
printf("%02x",encoded[done]);
}
printf(", %d chars decoded:",k);
for (done = 0; done < k; done++) {
printf("%c",answer[done]);
}
printf("\n");
#endif
							done = 1;
							break;
						}
					     curptr = curptr->left;
				   }
		
				   if (curptr->value >= 0) {
					     alpha_index += curptr->value;
					     /*printf("%d", alpha_index); */
#ifdef CUTILITIES_DEBUG
printf("Decoded value: %d, alpha_index = %d, char: %c\n", curptr->value,alpha_index,aa_syms[alpha_index]);
#endif
					     answer[k++] = aa_syms[alpha_index];
					     curptr = root; /* prepare to decode the next Huffman code */
				   } else {
					     if (curptr->value == -1) {
							 answer[k++] = '\0';
#ifdef CUTILITIES_DEBUG
printf("End of word, answer=%s\n",answer);
#endif
							 RETVAL = answer;
							 done = 1;
							 break;
					     }
				   }
			 }
		}
		
	OUTPUT:
		RETVAL
		
		
int
bitsAvailableForPrimeProducts()
	CODE:
		RETVAL = sizeof(Uverylong) * 8;
	OUTPUT:
		RETVAL

void
computePrimeProduct(peptide)
	char *peptide
	CODE:
		Uverylong m = static_computePrimeProduct(peptide);
		ST(0) = sv_newmortal();
		if (m > 0) {
			sv_setpvn(ST(0),(char *) &m, sizeof(m));
		} else {
			ST(0) = &PL_sv_undef;
		}

int
testManyPrimeProducts(product,peptides,multiples,answer)
	SV *product
	AV *peptides
	AV *multiples
	AV *answer

	CODE:
#ifdef WIN
{
#endif
		SV **sv;
		int i, count;
		STRLEN len;
		Uverylong u,divisor;
		char *p;
		int total = 0;

		av_clear(answer);
		p = SvPV(product,len);
		memcpy((char *) &divisor,p,len);
		count = av_len(peptides);
		for (i = 0; i <= count; i++) {
			sv = av_fetch(multiples,i,0);
			p = SvPV(*sv,len);
			memcpy(&u,p,len);
			if (!(divisor % u)) {
				sv = av_fetch(peptides,i,0);
				av_push(answer,*sv);
				SvREFCNT_inc(*sv);
				total++;
			}
		}
		RETVAL = total;
#ifdef WIN
}
#endif
	OUTPUT:
		RETVAL
		
int
computeManyPrimeProducts(peptides,multiples)
	AV *peptides
	AV *multiples
	CODE:
#ifdef WIN
{
#endif
		int i, count;
		Uverylong val;
		char *p;
		SV *sv;
		SV **pv;
		STRLEN len;

		count = av_len(peptides);
		av_extend(multiples,count);
		RETVAL = count+1;
		for (i = 0; i <= count; i++) {
			pv = av_fetch(peptides,i,0);
			p = SvPV(*pv,len);
			val = static_computePrimeProduct(p);
			if (val == 0) {
				RETVAL = -i;
				break;
			} else {
				sv = newSVpvn((char *) &val, sizeof(val));
				av_store(multiples,i,sv);
			}
		}
#ifdef WIN
}
#endif

	OUTPUT:
		RETVAL
		
void
encodeAsBitString(peptide)
	char *peptide
	CODE:
		int lastindex = -1;
		int thisindex;
		int unused = 0;
		int i;
		int bitcount;
		char *p;
		static int inited = 0;
		static char *revindex;
		static int bitmax[22];
		static int bitmaxcount = 0;
		static int outsize;
		static unsigned char *tempout;
		unsigned char *out;
		SV *mysv;
		STRLEN len;

		if (!inited) {
			int thesize = sizeof(lookup)/sizeof(lookup[0]);
			int bits;
			int j = 0;

			revindex = malloc(thesize * sizeof(revindex[0]));
			inited = 1;
			bitcount = 0;
			for (i = 0; i < thesize; i++) {
				if (lookup[i]) {
					revindex[i] = j++;
					bits = (int)(2000.0 / lookup[i]) + 1;
					bitmax[bitmaxcount++] = bits;
					bitcount += bits;
				} else {
					revindex[i] = -2;
				}
			}
			outsize = (bitcount+7)/8;
			tempout = malloc(outsize+2); /* a few extra bytes for good measure */
#ifdef CUTILITIES_DEBUG
printf("Running encodeAsBitString initialization code, bitmaxcount=%d,outsize=%d\n",bitmaxcount,outsize);
#endif /* CUTILITIES_DEBUG */
		}

		memset(tempout,'\0',outsize);
		mysv = newSVpvn(tempout,outsize);
		out = SvPV(mysv,len);
		bitcount = 0;
#ifdef CUTILITIES_DEBUG
printf("Setting %d zero bytes at %lx\n",outsize,(long) out);
#endif /* CUTILITIES_DEBUG */

		for (p = peptide; *p; p++) {
			if ((thisindex = revindex[*p]) < 0) {
#ifdef CUTILITIES_DEBUG
printf ("Error encoding bitstring for %s, char=%d\n",peptide,*p);
#endif /* CUTILITIES_DEBUG */
			}
			if (thisindex != lastindex) {
				for (i = lastindex; i < thisindex;) {
					/* extend bitstring here by #unused 0s */
					bitcount += unused;
					unused = bitmax[++i];
				}
				lastindex = thisindex;
			}
			/* append 1 to bitstring here */
			out[bitcount/8] |= (1 << (bitcount % 8));
#ifdef CUTILITIES_DEBUG
printf("Appending 1 at position %d for %s, output byte is now: %x\n",bitcount,peptide, out[bitcount/8]);
#endif /* CUTILITIES_DEBUG */
			bitcount++;
			unused--;
		}

		thisindex = bitmaxcount;
		for (i = lastindex; i < thisindex;) {
			/* extend bitstring here by #unused 0s */
			bitcount += unused;
			unused = bitmax[++i];
		}

		ST(0) = mysv;
#ifdef CUTILITIES_DEBUG
printf("Returning a %d byte string for %s\n",(bitcount+7)/8,peptide);
for (i = 0; i < outsize; i++) {
printf("%02x",out[i]);
}
printf("\n");
#endif /* CUTILITIES_DEBUG */

int
testManyBitStrings(encodedCandidate,peptides,bitstrings,answer)
	SV *encodedCandidate
	AV *peptides
	AV *bitstrings
	AV *answer

	CODE:
#ifdef WIN
{
#endif
		SV **sv;
		int i, count;
		STRLEN len;
#ifdef USE_VERYLONG
#define OURLONG Uverylong
#else
#define OURLONG unsigned long
#endif
		OURLONG u[20],v[20]; /* this may not work correctly if there are an odd # of 32-bit words */
		OURLONG *uPtr,*vPtr,*maxUPtr;
		OURLONG val;
		int longlongwordlen;
		char *p;
		int total = 0;
#ifdef CUTILITIES_DEBUG
int j;
#endif /* CUTILITIES_DEBUG */

		av_clear(answer);
		p = SvPV(encodedCandidate,len);
		memcpy((char *) v,p,len);
		longlongwordlen = (len+sizeof(u[0])-1)/sizeof(u[0]);
		u[longlongwordlen-1] = 0;
		v[longlongwordlen-1] = 0;
		count = av_len(peptides);
		maxUPtr = &u[longlongwordlen];
#ifdef CUTILITIES_DEBUG
printf("Len: %d, count: %d\n",len,count);
#endif /* CUTILITIES_DEBUG */
		for (i = 0; i <= count; i++) {
			sv = av_fetch(bitstrings,i,0);
			p = SvPV(*sv,len);
			memcpy(u,p,len);
#ifdef CUTILITIES_DEBUG
printf("iteration %d, fetched %d bytes\n",i,len);
j=0;
#endif /* CUTILITIES_DEBUG */
			for (uPtr = u, vPtr = v; uPtr < maxUPtr; uPtr++, vPtr++) {
				if ((val = ((*uPtr & *vPtr) ^ *uPtr))) {
#ifdef CUTILITIES_DEBUG
printf("D:%d,%lx,%lx,%lx\n",uPtr-u,*uPtr,*vPtr,val);
#endif /* CUTILITIES_DEBUG */
					break;
				}
#ifdef CUTILITIES_DEBUG
j++;
#endif /* CUTILITIES_DEBUG */
			}
#ifdef CUTILITIES_DEBUG
printf("j:%d ",j);
#endif /* CUTILITIES_DEBUG */
			if (! val) {
#ifdef CUTILITIES_DEBUG
printf("*");
#endif /* CUTILITIES_DEBUG */
				sv = av_fetch(peptides,i,0);
				av_push(answer,*sv);
				SvREFCNT_inc(*sv);
				total++;
			}
		}
		RETVAL = total;
#ifdef WIN
}
#endif
	OUTPUT:
		RETVAL

int
binarySearchSpectrum(mass,extended_spectrum)
	double mass
	AV *extended_spectrum
	CODE:
#ifdef WIN
{
#endif
		int mid,low,high;
		double val;
		SV **sv;

		low = 0;
		high = av_len(extended_spectrum);
		while (low <= high) {
			mid = (low+high)/2;
			sv = av_fetch(extended_spectrum,mid,0);
			val = SvNV(*sv);
			if (mass < val) 
				high = mid - 1;
			else
				low = mid + 1;
		}
		if (mass > val) mid++;
		RETVAL = mid;
#ifdef WIN
}
#endif
	OUTPUT:
		RETVAL

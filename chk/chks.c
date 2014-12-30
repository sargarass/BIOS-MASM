#define _CRT_SECURE_NO_DEPRECATE
#include <stdio.h>

#define countof(a)	(sizeof(a)/sizeof((a)[0]))

int main( int ac, char **av )
{
	int	i, n, j;
	FILE	*fp;
	char	chks;
	char	buf[ 4096 ];

	for ( i=1; i<ac; i++ ) {
		fp = fopen( av[i], "r+b" );
		if ( !fp ) {
			fprintf( stderr, "Can't open '%s'\n", av[i] );
		} else {
			fprintf( stderr, "File '%s' was open\n", av[i] );
			chks = '\0';
			while ( !feof( fp ) ) {
				n = fread( buf, 1, countof(buf), fp );
				for ( j=0; j<n; j++ ) chks += buf[j];
			}

			fprintf( stderr, "checksum is 0x%02lX\n", (unsigned char)chks );
			fseek( fp, 0L, SEEK_SET );
			n = fread( buf, 1, countof(buf), fp );
			fprintf( stderr, "was readed %d bytes\n", n );
			for ( j=0; j<n-1; j++ ) if ( *(unsigned short int*)(buf+j) == 0xFFFFU ) {
				chks = (char)( 0x1FFU - (unsigned)(unsigned char)chks );
				fseek( fp, j, SEEK_SET );
				if ( fwrite( &chks, 1, 1, fp ) == 1 ) {
					fprintf( stderr, "found signature at offset 0x%08lX, written value is 0x%02lX\n", j, (unsigned char)chks );
				} else {
					fprintf( stderr, "can't write right\n" );
				}
				break;
			}
			if ( j >=n-1 ) {
				fprintf( stderr, "Can't find signature 0xFFFF at first 4K\n" );
			}
			fclose( fp );
		}
	}
}

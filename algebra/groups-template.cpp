
template<class S> S& operator<<(S &stream, imat &table)
{
	int n = table.shape()[0];
	int m = table.shape()[1];
	
	stream << "\n";
	stream << "+" << ",";
	for (int i=0; i<m; i++) {
		stream << i;
		if (i<m-1) stream << ",";
	}
	stream << "\n";
	
	for (int i=0; i<n; i++) {
		stream << i << ",";
		
		for (int j=0; j<m; j++) {
			stream << table[i][j];
			if (j<m-1) stream << ",";
		}
		
		stream << "\n";
	}
	
	stream << "\n";
	
	return stream;
}

/*
Runs the goldbug-like hunger game on an N lattice, where chips are continually inserted at state 2 and absorbed at either 0 or 1.
Each state v has outgoing edges to v-2 and v+1, and in this example hunger is scaled up so that each edge has weight 1.
Input: number of firings, including inserting chips.
Output: hunger state for each firing / insertion and the update of hunger.
During the insertion step, where the previous chip was absorbed (L versus R for states 0 versus 1) will be recorded.
*/

#include <iostream>
#include <fstream>
#include <string>
#include <math.h>
#include <algorithm>
#include <utility>
#include <string.h>
#include <iterator>
#include <vector>
#include <iomanip>
#include <cmath>
#include <map>
#include <queue>
#include <set>
#include <unordered_set>

using namespace std;

const int infinity = 100000;
const double phi = 1.6180339887498948482045868343656;


ofstream fout;


void output(char status, vector<int> h, int pos, int reach, int t, bool forbidden) {
	bool zero = true;
	fout << status;
	for (int i = 0; i <= reach; i++) {
		if (h[i] != 0)
			zero = false;
		fout << ' ';
		fout << h[i];
		if (i == pos)
			fout << '!';
	}
	if (zero)
		fout << " All-zero: " << pos - 1 << ' ' << t;
	if (forbidden)
		fout << " Forbidden_jump";
	fout << endl;
}

bool scanOutput(vector<int> h, int pos, int reach, int t, bool forbidden, int absorbcount) {
	bool zero = true;
	for (int i = 0; i <= reach; i++) {
		if (h[i] != 0) {
			zero = false;
			break;
		}
	}
	if (zero)
		fout << " All-zero: " << pos - 1 << ' ' << t << ' ' << absorbcount;
	if (forbidden)
		fout << " Forbidden_jump";
	if (zero || forbidden)
		fout << endl;
	return zero;
}

int L1(vector<int> h, int reach) {
	int norm = 0;
	for (int i = 0; i <= reach + 10; i++)
		norm += abs(h[i]);
	return norm;
}

// Full information, hunger states, all-zero configurations, forbidden jumps
int fullInfo() {

	fout.open("fullInfo.out");
	cout << "List how many firings you would like: ";
	int n;
	cin >> n;


	//Initialize
	vector<int> h(infinity, 0);
	int t = 0;
	int pos = 2;
	int reach = 2;
	vector<int> absorb(2, 0);
	bool forbidden = false;
	output('S', h, pos, reach, t, forbidden);
	
	//First update
	if (pos + 1 > reach)
		reach = pos + 1;
	h[pos - 2]++;
	h[pos + 1]++;
	output('H', h, pos, reach, t, false);

	for (t = 1; t <= n; t++) {
		//Fire
		int mhp = 0; //Max hunger position, ties given to earliest
		for (int i = 1; i <= reach; i++) {
			if (h[i] > h[mhp])
				mhp = i;
		}
		if (pos - mhp == 2 || mhp - pos == 1)
			forbidden = false;
		else
			forbidden = true;
		pos = mhp;
		h[pos] -= 2;
		output('F', h, pos, reach, t, forbidden);

		//Update if non-absorbing
		if (pos > 1) {
			if (pos + 1 > reach)
				reach = pos + 1;
			h[pos - 2]++;
			h[pos + 1]++;
			output('H', h, pos, reach, t, false);
		}

		//Absorb, re-insert, update if absorbing
		if (pos == 0) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			output('L', h, pos, reach, t, false);
			absorb[0]++;
		}
		if (pos == 1) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			output('R', h, pos, reach, t, false);
			absorb[1]++;
		}
	}

	fout << absorb[0] << ' ' << absorb[1] << endl;

	return 0;

}

// Number of absorptions between all-zero configurations, forbidden jumps
int allZero() {

	fout.open("allZero.out");
	cout << "List how many firings you would like: ";
	int n;
	cin >> n;

	//Initialize
	vector<int> h(infinity, 0);
	int t = 0;
	int pos = 2;
	int reach = 2;
	int absorbcount = 0; //temporary absorb count between all-zero configurations
	vector<int> absorb(2, 0);
	bool forbidden = false;
	if (scanOutput(h, pos, reach, t, forbidden, absorbcount))
		absorbcount = 0;

	//First update
	if (pos + 1 > reach)
		reach = pos + 1;
	h[pos - 2]++;
	h[pos + 1]++;

	for (t = 1; t <= n; t++) {
		//Fire
		int mhp = 0; //Max hunger position, ties given to earliest
		for (int i = 1; i <= reach; i++) {
			if (h[i] > h[mhp])
				mhp = i;
		}
		if (pos - mhp == 2 || mhp - pos == 1)
			forbidden = false;
		else
			forbidden = true;
		pos = mhp;
		h[pos] -= 2;
		if (scanOutput(h, pos, reach, t, forbidden, absorbcount))
			absorbcount = 0;

		//Update if non-absorbing
		if (pos > 1) {
			if (pos + 1 > reach)
				reach = pos + 1;
			h[pos - 2]++;
			h[pos + 1]++;
		}

		//Absorb, re-insert, update if absorbing
		if (pos == 0) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			absorbcount++;
			absorb[0]++;
		}
		if (pos == 1) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			absorbcount++;
			absorb[1]++;
		}
	}

	fout << absorb[0] << ' ' << absorb[1] << endl;

	return 0;

}

//Full information, hunger states, all-zero configurations, forbidden jumps,
//but in ties, rightmost hungriest vertex is chosen instead
int fullInfoR() {
	fout.open("fullInfoR.out");
	cout << "List how many firings you would like: ";
	int n;
	cin >> n;


	//Initialize
	vector<int> h(infinity, 0);
	int t = 0;
	int pos = 2;
	int reach = 2;
	vector<int> absorb(2, 0);
	bool forbidden = false;
	output('S', h, pos, reach, t, forbidden);

	//First update
	if (pos + 1 > reach)
		reach = pos + 1;
	h[pos - 2]++;
	h[pos + 1]++;
	output('H', h, pos, reach, t, false);

	for (t = 1; t <= n; t++) {
		//Fire
		int mhp = 0; //Max hunger position, ties given to earliest
		for (int i = 1; i <= reach; i++) {
			if (h[i] >= h[mhp])
				mhp = i;
		}
		if (pos - mhp == 2 || mhp - pos == 1)
			forbidden = false;
		else
			forbidden = true;
		pos = mhp;
		h[pos] -= 2;
		output('F', h, pos, reach, t, forbidden);

		//Update if non-absorbing
		if (pos > 1) {
			if (pos + 1 > reach)
				reach = pos + 1;
			h[pos - 2]++;
			h[pos + 1]++;
			output('H', h, pos, reach, t, false);
		}

		//Absorb, re-insert, update if absorbing
		if (pos == 0) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			output('L', h, pos, reach, t, false);
			absorb[0]++;
		}
		if (pos == 1) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			output('R', h, pos, reach, t, false);
			absorb[1]++;
		}
	}

	fout << absorb[0] << ' ' << absorb[1] << endl;

	return 0;
	fout.close();
}

// If a new max hunger value is reached, output at what time step
int maxHunger() {
	fout.open("maxHunger.out");
	cout << "List how many firings you would like: ";
	int n;
	cin >> n;

	//Initialize
	vector<int> h(infinity, 0);
	int t = 0;
	int pos = 2;
	int reach = 2;
	int maxh = 0;

	//First update
	if (pos + 1 > reach)
		reach = pos + 1;
	h[pos - 2]++;
	h[pos + 1]++;
	if (h[pos - 2] > maxh || h[pos+1] > maxh) {
		maxh = max(h[pos - 2], h[pos + 1]);
		fout << maxh << ' ' << t << endl;
	}

	for (t = 1; t <= n; t++) {
		//Fire
		int mhp = 0; //Max hunger position, ties given to earliest
		for (int i = 1; i <= reach; i++) {
			if (h[i] > h[mhp])
				mhp = i;
		}
		pos = mhp;
		h[pos] -= 2;
		//Update if non-absorbing
		if (pos > 1) {
			if (pos + 1 > reach)
				reach = pos + 1;
			h[pos - 2]++;
			h[pos + 1]++;
			if (h[pos - 2] > maxh || h[pos + 1] > maxh) {
				maxh = max(h[pos - 2], h[pos + 1]);
				fout << maxh << ' ' << t << endl;
			}
		}
		//Absorb, re-insert, update if absorbing
		if (pos == 0) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			if (h[pos - 2] > maxh || h[pos + 1] > maxh) {
				maxh = max(h[pos - 2], h[pos + 1]);
				fout << maxh << ' ' << t << endl;
			}
		}
		if (pos == 1) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			if (h[pos - 2] > maxh || h[pos + 1] > maxh) {
				maxh = max(h[pos - 2], h[pos + 1]);
				fout << maxh << ' ' << t << endl;
			}
		}
	}

	return 0;
}

// Full information, but using L1 firing rules
int fullInfoL1() {
	fout.open("fullInfoL1.out");
	cout << "List how many firings you would like: ";
	int n;
	cin >> n;


	//Initialize
	vector<int> h(infinity, 0);
	int t = 0;
	int pos = 2;
	int reach = 2;
	vector<int> absorb(2, 0);
	bool forbidden = false;
	output('S', h, pos, reach, t, forbidden);

	//First update
	if (pos + 1 > reach)
		reach = pos + 1;
	h[pos - 2]++;
	h[pos + 1]++;
	output('H', h, pos, reach, t, false);

	for (t = 1; t <= n; t++) {
		//Fire
		int minNorm = infinity;
		vector<int> h2;
		int chiprec; // Position that will receive the chip
		//State 0 receives chip, reinsert at 2
		h2 = h;
		h2[0]--;
		h2[3]++;
		if (L1(h2, reach) < minNorm) {
			minNorm = L1(h2, reach);
			chiprec = 0;
		}
		//State 1 receives chip, reinsert at 2
		h2 = h;
		h2[0]++;
		h2[1] -= 2;
		h2[3]++;
		if (L1(h2, reach) < minNorm) {
			minNorm = L1(h2, reach);
			chiprec = 1;
		}
		//Non-absorbing state receives chip
		for (int i = 2; i <= reach; i++) {
			h2 = h;
			h2[i - 2]++;
			h2[i] -= 2;
			h2[i + 1]++;
			if (L1(h2, reach) < minNorm) {
				minNorm = L1(h2, reach);
				chiprec = i;
			}
		}
		if (pos - chiprec == 2 || chiprec - pos == 1)
			forbidden = false;
		else
			forbidden = true;
		pos = chiprec;
		h[pos] -= 2;
		output('F', h, pos, reach, t, forbidden);

		//Update if non-absorbing
		if (pos > 1) {
			if (pos + 1 > reach)
				reach = pos + 1;
			h[pos - 2]++;
			h[pos + 1]++;
			output('H', h, pos, reach, t, false);
		}

		//Absorb, re-insert, update if absorbing
		if (pos == 0) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			output('L', h, pos, reach, t, false);
			absorb[0]++;
		}
		if (pos == 1) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			output('R', h, pos, reach, t, false);
			absorb[1]++;
		}
	}

	fout << absorb[0] << ' ' << absorb[1] << endl;

	return 0;
}

// Find value of a - b\phi, where a is the number of times the left state absorbs chips
// and b is the number of times the right state absorbs chips.
// For both the classical and L1 hunger game.
int deviation() {
	fout.open("deviation.out");
	cout << "List how many firings you would like: ";
	int n;
	cin >> n;


	//Initialize. First index 0 for classic, 1 for L1
	vector<vector<int>> h(2,vector<int>(infinity,0));
	int t = 0;
	vector<int> pos(2,2);
	vector<int> reach(2,2);
	vector<vector<int>> absorb(2, vector<int>(2, 0));
	vector<vector<double>> deviation(2); 

	//First update
	for (int i = 0; i <= 1; i++) {
		if (pos[i] + 1 > reach[i])
			reach[i] = pos[i] + 1;
		h[i][pos[i] - 2]++;
		h[i][pos[i] + 1]++;
	}

	for (t = 1; t <= n; t++) {
		//Fire Classic
		int mhp = 0; //Max hunger position, ties given to earliest
		for (int i = 1; i <= reach[0]; i++) {
			if (h[0][i] > h[0][mhp])
				mhp = i;
		}

		pos[0] = mhp;
		h[0][pos[0]] -= 2;

		//Fire L1
		int minNorm = infinity;
		vector<int> h2;
		int chiprec; // Position that will receive the chip
		//State 0 receives chip, reinsert at 2
		h2 = h[1];
		h2[0]--;
		h2[3]++;
		if (L1(h2, reach[1]) < minNorm) {
			minNorm = L1(h2, reach[1]);
			chiprec = 0;
		}
		//State 1 receives chip, reinsert at 2
		h2 = h[1];
		h2[0]++;
		h2[1] -= 2;
		h2[3]++;
		if (L1(h2, reach[1]) < minNorm) {
			minNorm = L1(h2, reach[1]);
			chiprec = 1;
		}
		//Non-absorbing state receives chip
		for (int i = 2; i <= reach[1]; i++) {
			h2 = h[1];
			h2[i - 2]++;
			h2[i] -= 2;
			h2[i + 1]++;
			if (L1(h2, reach[1]) < minNorm) {
				minNorm = L1(h2, reach[1]);
				chiprec = i;
			}
		}
		pos[1] = chiprec;
		h[1][pos[1]] -= 2;

		for (int i = 0; i <= 1; i++) {
			//Update if non-absorbing
			if (pos[i] > 1) {
				if (pos[i] + 1 > reach[i])
					reach[i] = pos[i] + 1;
				h[i][pos[i] - 2]++;
				h[i][pos[i] + 1]++;
			}

			//Absorb, re-insert, update if absorbing
			if (pos[i] == 0) {
				pos[i] = 2;
				h[i][pos[i] - 2]++;
				h[i][pos[i] + 1]++;
				absorb[i][0]++;
				double a = absorb[i][0];
				double b = absorb[i][1];
				deviation[i].push_back(a - b * phi);
			}
			else if (pos[i] == 1) {
				pos[i] = 2;
				h[i][pos[i] - 2]++;
				h[i][pos[i] + 1]++;
				absorb[i][1]++;
				double a = absorb[i][0];
				double b = absorb[i][1];
				deviation[i].push_back(a - b * phi);
			}
		}
	}

	fout << "Classic";
	for (int i = 0; i < deviation[0].size(); i++) {
		fout << ' ' << deviation[0][i];
	}
	fout << endl;
	fout << "L1";
	for (int i = 0; i < deviation[1].size(); i++) {
		fout << ' ' << deviation[1][i];
	}
	fout << endl;

	return 0;
}

// Counts the maximum number of 1s (2s in the simulation) present in any hunger state reached
int max1() {
	fout.open("max1.out");
	cout << "List how many firings you would like: ";
	int n;
	cin >> n;

	//Initialize
	vector<int> h(infinity, 0);
	int t = 0;
	int pos = 2;
	int reach = 2;
	int maxo = -1;
	int ocount = 0;

	//First update
	if (pos + 1 > reach)
		reach = pos + 1;
	h[pos - 2]++;
	h[pos + 1]++;
	for (int i = 0; i <= reach; i++) {
		if (h[i] == 2) {
			ocount++;
		}
	}
	if (ocount > maxo) {
		maxo = ocount;
		fout << maxo << ' ' << t << endl;
	}

	for (t = 1; t <= n; t++) {
		//Fire
		int mhp = 0; //Max hunger position, ties given to earliest
		for (int i = 1; i <= reach; i++) {
			if (h[i] > h[mhp])
				mhp = i;
		}
		pos = mhp;
		h[pos] -= 2;
		//Update if non-absorbing
		if (pos > 1) {
			if (pos + 1 > reach)
				reach = pos + 1;
			h[pos - 2]++;
			h[pos + 1]++;
			ocount = 0;
			for (int i = 0; i <= reach; i++) {
				if (h[i] == 2) {
					ocount++;
				}
			}
			if (ocount > maxo) {
				maxo = ocount;
				fout << maxo << ' ' << t << endl;
			}
		}
		//Absorb, re-insert, update if absorbing
		if (pos == 0) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			ocount = 0;
			for (int i = 0; i <= reach; i++) {
				if (h[i] == 2) {
					ocount++;
				}
			}
			if (ocount > maxo) {
				maxo = ocount;
				fout << maxo << ' ' << t << endl;
			}
		}
		if (pos == 1) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			ocount = 0;
			for (int i = 0; i <= reach; i++) {
				if (h[i] == 2) {
					ocount++;
				}
			}
			if (ocount > maxo) {
				maxo = ocount;
				fout << maxo << ' ' << t << endl;
			}
		}
	}

	return 0;
}

// Counts the position at which the chip turns towards the absorbing states
// (i.e. the farthest the arc goes)
// Note: this program takes as an input the number of chips, not the number of firings.
int arcDist() {
	fout.open("arcDist.out");
	cout << "List how many chips you would like to be absorbed: ";
	int n;
	cin >> n;


	//Initialize
	vector<int> h(infinity, 0);
	int t = 1;
	int pos = 2;
	int reach = 2;
	bool turn = false;
	bool forbidden = false;

	//First update
	if (pos + 1 > reach)
		reach = pos + 1;
	h[pos - 2]++;
	h[pos + 1]++;

	while (t <= n) {
		//Fire
		int mhp = 0; //Max hunger position, ties given to earliest
		for (int i = 1; i <= reach; i++) {
			if (h[i] > h[mhp])
				mhp = i;
		}
		if (pos - mhp == 2 || mhp - pos == 1)
			forbidden = false;
		else
			forbidden = true;
		if (forbidden) {
			fout << "Forbidden_jump_on_chip: " << t << endl;
		}
		// In the case that we turn, output the chip number, whether it will be absorbed
		// By the left or right absorbing state, and at what position it turned at.
		// Note that in this program the left or right absorbing states are 0 and 1,
		// But they are -1 and 0 in the mathematical formulation, so position is reduced by 1.
		if (pos - mhp == 2 && !turn) {
			turn = true;
			if (pos % 2 == 0) // Will be absorbed by left
				fout << t << " L " << pos - 1 << endl;
			else // Will be absorbed by right
				fout << t << " R " << pos - 1 << endl;
		}
		pos = mhp;
		h[pos] -= 2;

		//Update if non-absorbing
		if (pos > 1) {
			if (pos + 1 > reach)
				reach = pos + 1;
			h[pos - 2]++;
			h[pos + 1]++;
		}

		//Absorb, re-insert, update if absorbing
		if (pos == 0) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			t++;
			turn = false;
		}
		if (pos == 1) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			t++;
			turn = false;
		}
	}

	return 0;
}

// Using given hunger vector with chip position, output absorbed states
int infoInit() {
	fout.open("infoInit.out");
	cout << "List how many chips you would like to be absorbed: ";
	int n;
	cin >> n;


	//Initialize
	vector<int> h(infinity, 0);
	string hin = "";
	int reach = -1;
	cout << endl << "Provide the digits of the hunger vector scaled up by 2, starting at state -1: ";
	cin >> hin;
	while (hin != "Done") {
		reach++;
		h[reach] = stoi(hin);
		cout << ' ';
		cin >> hin;
	}
	cout << endl;
	cout << "Provide the location of the chip: ";
	int pos = 2;
	cin >> pos;
	pos++;
	cout << endl << "Do you wish to suppress forbidden jump notices? (Y/N) ";
	cin >> hin;
	bool suppress = false;
	if (hin == "Y")
		suppress = true;
	int t = 1;
	reach = max(reach,2);
	bool forbidden = false;
	int lastForbidden = 0;

	while (t <= n) {
		//Fire
		int mhp = 0; //Max hunger position, ties given to earliest
		for (int i = 1; i <= reach; i++) {
			if (h[i] > h[mhp])
				mhp = i;
		}
		if (pos - mhp == 2 || mhp - pos == 1)
			forbidden = false;
		else
			forbidden = true;
		if (forbidden) {
			lastForbidden = t;
			if (!suppress) {
				fout << "Forbidden_jump_on_chip: " << t << endl;
			}
		}
		pos = mhp;
		h[pos] -= 2;

		//Update if non-absorbing
		if (pos > 1) {
			if (pos + 1 > reach)
				reach = pos + 1;
			h[pos - 2]++;
			h[pos + 1]++;
		}

		//Absorb, re-insert, update if absorbing
		else {
			if (pos == 0) {
				output('L', h, pos, reach, t, false);
			}
			else {
				output('R', h, pos, reach, t, false);
			}
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			t++;
		}
	}

	fout << "Last_forbidden_jump_during_chip: " << lastForbidden << endl;

	return 0;

}

// Counts the number of times each state is visited
int visitVector() {
	fout.open("visitVector.out");
	cout << "List how many chips you would like to be absorbed: ";
	int n;
	cin >> n;
	cout << "List how many states you would like to track: ";
	int visreach;
	cin >> visreach;
	visreach++;

	//Initialize
	vector<int> h(infinity, 0);
	vector<int> visit(infinity, 0);
	int t = 1;
	int pos = 2;
	int reach = 2;
	bool turn = false;
	bool forbidden = false;

	//First update
	if (pos + 1 > reach)
		reach = pos + 1;
	h[pos - 2]++;
	h[pos + 1]++;

	while (t <= n) {
		//Fire
		int mhp = 0; //Max hunger position, ties given to earliest
		for (int i = 1; i <= reach; i++) {
			if (h[i] > h[mhp])
				mhp = i;
		}
		/*if (pos - mhp == 2 || mhp - pos == 1)
			forbidden = false;
		else
			forbidden = true;
		if (forbidden) {
			fout << "Forbidden_jump_on_chip: " << t << endl;
		}*/
		// In the case that we turn, output the chip number, whether it will be absorbed
		// By the left or right absorbing state, and at what position it turned at.
		// Note that in this program the left or right absorbing states are 0 and 1,
		// But they are -1 and 0 in the mathematical formulation, so position is reduced by 1.
		if (pos - mhp == 2 && !turn) {
			turn = true;
			/*if (pos % 2 == 0) // Will be absorbed by left
				fout << t << " L " << pos - 1 << endl;
			else // Will be absorbed by right
				fout << t << " R " << pos - 1 << endl;*/
			// At this point, pos is the peak of the arc
			for (int i = 2; i <= pos; i++) {
				visit[i]++;
			}
			for (int i = pos - 2; i >= 0; i -= 2) {
				visit[i]++;
			}
			for (int i = 0; i <= visreach; i++) {
				fout << visit[i] << ' ';
			}
			fout << endl;
		}
		pos = mhp;
		h[pos] -= 2;

		//Update if non-absorbing
		if (pos > 1) {
			if (pos + 1 > reach)
				reach = pos + 1;
			h[pos - 2]++;
			h[pos + 1]++;
		}

		//Absorb, re-insert, update if absorbing
		if (pos == 0) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			t++;
			turn = false;
		}
		if (pos == 1) {
			pos = 2;
			h[pos - 2]++;
			h[pos + 1]++;
			t++;
			turn = false;
		}
	}

	return 0;
}

int main() {
	return visitVector();
}
/*
 * 	IBASAM : Individual Based Atlantic SAlmon Model
 *
 * 	Cyril Piou, 2009-2010, part of the Salmo salar individual based model metaIbasam
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  Any questions or remarks, please contact Cyril Piou at:
 *
 *  cyril.piou<at>cirad.fr
 *
 */

#ifndef GENEMAP_H_
#define GENEMAP_H_
#include <boost/dynamic_bitset.hpp>
#include "rand.h"
using namespace std;
typedef boost::dynamic_bitset<> dbitset;

class Genemap
{
public:
	Genemap();
	Genemap(double mean, double sd);
	Genemap(unsigned nloci, double heritability, double mean, double sd);
	Genemap(dbitset b1, dbitset b2, double heritability, double mean, double sd);
	dbitset reassort();
	double standardized_value();
	double expression();
	double phenotype();
	virtual ~Genemap();
	double liminf() const{return liminf_;};
	double limsup() const{return limsup_;};
	double heritability() const{return heritability_;};
	double mean() const{return mean_;};
	double sd() const{return sd_;};
	dbitset br1o() const{return br1;};
	dbitset br2o() const{return br2;};

private:
	void initialize_lims();
	dbitset br1;
	dbitset br2;
	unsigned nloci_;
	double liminf_ , limsup_ , heritability_;
	double mean_,sd_;
};

Genemap reproduction(Genemap *mother, Genemap* father);

void populateBitSet (std::string &buffer, dbitset & bitMap);

std::ostream& operator<<(std::ostream& os, Genemap& gm);

#endif /* GENEMAP_H_ */
